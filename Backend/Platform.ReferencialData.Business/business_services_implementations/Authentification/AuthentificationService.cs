using login.data.PostgresConn;
using login.models;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Configuration;

using Platform.ReferencialData.Business.business_services.Authentification;
using System.IdentityModel.Tokens.Jwt;

using System.Security.Claims;
using System.Text;
using Microsoft.IdentityModel.Tokens;

using Platform.ReferentialData.DtoModel.Authentification;
using WebApplication1.models;
using Platform.ReferentialData.DataModel.Authentification;
using Microsoft.EntityFrameworkCore;

namespace Platform.ReferencialData.Business.business_services_implementations.Authentification
{
    public class AuthentificationService : IAuthentificationService
    {
        private readonly Postgres _context;
        private readonly UserManager<employer3> _usermanager;
        private readonly IConfiguration _configuration; 
        private readonly RoleManager<IdentityRole> _RoleManager;
        private string jwtToken;

        public AuthentificationService(UserManager<employer3> _usermanager , Postgres context, IConfiguration configuration, RoleManager<IdentityRole> roleManager)
        {
            this._usermanager = _usermanager;
            _context = context;
            _configuration = configuration;
            _RoleManager = roleManager;
        }
        public async Task<string?> GenerateJwtToken(employer3 user)
        {
            var JwtTokenHandler = new JwtSecurityTokenHandler();
            var claims = await GetClaims(user);
            var key = Encoding.UTF8.GetBytes(_configuration.GetSection("JwtConfig:secret").Value);
            var TokenDescription = new SecurityTokenDescriptor()
            {
                Subject = new ClaimsIdentity(claims),
                Expires = DateTime.UtcNow.Add(TimeSpan.Parse(_configuration.GetSection("JwtConfig:ExpiryTimeFrame").Value)),
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256)

            };
            Console.Write(_usermanager.GetRolesAsync(user));
            var token = JwtTokenHandler.CreateToken(TokenDescription);
            return  jwtToken =  JwtTokenHandler.WriteToken(token);
             /*var RefreshToken = new RefreshTokenModel(){
                 Id = Guid.NewGuid().ToString(),
                 JwtId = token.Id,
                 Token = RandomStringGeneration(23), //Generate  a refresh token
                 AddedDate = DateTime.UtcNow,
                 ExpiryDate = DateTime.UtcNow.AddMonths(6),
                 IsRevoked = false , 
                 IsUsed = false ,
                 UserId = user.Id
             };
              await _context.RefreshTokenTable.AddAsync(RefreshToken);
             await _context.SaveChangesAsync();
            return new authResult(){
                 Token = jwtToken,
                 RefreshToken = RefreshToken.Token,
                 Result = true
             };*/
        }

        private string RandomStringGeneration(int length)
        {
           
            var random = new Random();
            var chars = "ABCDEFGHIJKLMNOPORSTUVWXYZ1234567890abcdefghijklmnopgrstuvwxyz_";
            return new string(Enumerable.Repeat(chars, length).Select(s => s[random.Next(s.Length)]).ToArray());
        }

        public async Task<List<Claim>> GetClaims(employer3 user)
        {   
            var claims = new List<Claim> {
                    new Claim ("Id" , user.Id),
                    new Claim (JwtRegisteredClaimNames.Sub , user.Email),
                    new Claim (JwtRegisteredClaimNames.Email , user.Email),
                    new Claim (JwtRegisteredClaimNames.Jti , Guid.NewGuid().ToString()),
                    new Claim (JwtRegisteredClaimNames.Iat , DateTime.Now.ToFileTimeUtc().ToString()),

                };
            var userClaims = await _usermanager.GetClaimsAsync(user);
            claims.AddRange(userClaims);

            var userRoles = await _usermanager.GetRolesAsync(user);
            foreach (var userRole in userRoles)
            {

                var Role = await _RoleManager.FindByNameAsync(userRole);
                if (Role != null)
                {
                    claims.Add(new Claim(ClaimTypes.Role, userRole));
                    var Roleclaims = await _RoleManager.GetClaimsAsync(Role);
                    foreach (var roleClaim in Roleclaims)
                    {
                        claims.Add(roleClaim);
                    }
                }
            }

            return claims;
        }

        
        public async Task<authResult> is_usercreated(UserRegistrationRequestDto user)
        {
            
            
                // check if user exist
                var user_exist = await _usermanager.FindByEmailAsync(user.Email);

                if (user_exist != null)
                    return new authResult()
                    {
                        Result = false,
                        Errors = new List<string>(){
                        "Email already Exists"
                    }
                    };
                //create new instance of the Users table model
                var new_user = new employer3()
                {
                    UserName = user.Name,
                    Email = user.Email,
                    EmailConfirmed = false

                };



                // check if Role exist 
                var Role_exist = await _RoleManager.RoleExistsAsync(user.Role);
                
                if (Role_exist)
                {
                    // create user 
                    IdentityResult is_created = await _usermanager.CreateAsync(new_user, user.Password);
                   if (is_created.Succeeded) {
                        return new authResult()
                        {
                            Result = true,

                        };
                        }
                    else
                        {
                        List<string> errors = new List<string>();
                        foreach (var error in is_created.Errors)
                        {
                            errors.Add(error.Code + error.Description);
                        }
                        return new authResult()
                        {
                            Result = false,
                            Errors = errors
                        };

                            
                        };
                    
                 
                    
                }
                else
                {
                    return   new authResult()
                    {
                        Result = false,
                        Errors = new List<string>(){
                        "Role does not exist"
                    }
                    };

                }
                
            
          
        }
        public async Task RegisterEmployer(EmployerInfoDto employer)
        {
            
                var user = await _usermanager.FindByEmailAsync(employer.Email);
                var MoreInfo = new MoreInfoEmployer()
                {
                    IdMoreInfo = Guid.NewGuid().ToString(),
                    numeroTelEntreprise = employer.numeroTelEntreprise,
                    codeTVA = employer.codeTVA,
                    adresseFacturation = employer.adresseFacturation,
                    AdresseEntreprise = employer.AdresseEntreprise,
                    EmailRH = employer.EmailRH,
                    NumTelRH = employer.NumTelRH,
                    PaymentMethode = employer.PaymentMethode,
                    moreInfoId = user.Id
                };
                await _context.Employer.AddAsync(MoreInfo);
            
        }
       public async Task RegisterEmployee(EmployeeDto employee)
        {

            var user = await _usermanager.FindByEmailAsync(employee.Email);
            var Employee = new Employee()
            {
                EmployeeId = Guid.NewGuid().ToString(),
                NumTel = employee.NumTel,
                balance = employee.balance,
                moreInfoId = user.Id
            };
            await _context.Employee.AddAsync(Employee);
        }

        public async Task RegisterShopowner(shopownerDto user)
        {
         
                var Finduser = await _usermanager.FindByEmailAsync(user.Email);
                var MoreInfo = new ShopOwner()
                {   
                    ShopOwnerIdMoreInfo = Guid.NewGuid().ToString(),
                    Adresse = user.Adresse,
                    codeTVA = user.codeTVA,
                    adresseFacturation = user.adresseFacturation,          
                    NumTel = user.NumTel,
                    PaymentMethode = user.PaymentMethode,
                    moreInfoId = Finduser.Id
                };
                await _context.Shopowner.AddAsync(MoreInfo);
            
        }

        public object GetUserAsync(string id)
        {
            throw new NotImplementedException();
        }



        public async Task RegisterCasier(CassierDto cassier)
        {
            var user = await _usermanager.FindByEmailAsync(cassier.Email);
            var casier = new Cassier()
            {
                CasierId = Guid.NewGuid().ToString(),

                moreInfoId = user.Id,
                balance = cassier.balance,
                adresse = cassier.adresse,
            };
            await _context.Cassier.AddAsync(casier);
        }
    }
   
}
