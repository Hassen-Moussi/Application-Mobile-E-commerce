using System.Diagnostics.Eventing.Reader;
using System.IdentityModel.Tokens.Jwt;
using System.Net.WebSockets;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using login.data.PostgresConn;
using login.models;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.Owin.Security.Infrastructure;
using Microsoft.Owin.Security.Jwt;
using Newtonsoft.Json.Linq;
using Org.BouncyCastle.Asn1.Ocsp;
using Platform.ReferencialData.Business.business_services.Authentification;
using Platform.ReferencialData.Business.business_services_implementations.Authentification;
using Platform.ReferencialData.Business.Helper;
using Platform.ReferentialData.DataModel.Authentification;
using Platform.ReferentialData.DtoModel.Authentification;
using RepositoryServices.StaticMethods;
using SmtpServer.Text;
using WebApplication1.models;
using static Org.BouncyCastle.Bcpg.Attr.ImageAttrib;

namespace Platform.ReferencialData.WebAPI.Controllers.Authentification
{
    [ApiController]
    [Route("[controller]")]

    public class AuthentificationController : ControllerBase
    {

        private readonly UserManager<employer3> _usermanager;
        private readonly RoleManager<IdentityRole> _RoleManager;
        private readonly IConfiguration _configuration;
        private readonly IAuthentificationService _authentificationService;
        private readonly TokenValidationParameters _tokenValidationParams;
        private readonly Postgres _context;
        public AuthentificationController(UserManager<employer3> _usermanager, Postgres context, RoleManager<IdentityRole> _RoleManager, IConfiguration _configuration, IAuthentificationService _authentificationService, TokenValidationParameters tokenValidationParameters)
        {
            this._usermanager = _usermanager;
            this._configuration = _configuration;
            this._RoleManager = _RoleManager;
            _context = context;
            this._authentificationService = _authentificationService;
            _tokenValidationParams = tokenValidationParameters;
        }

        ///------------ Addrole methode 
        [HttpPost]
        [Route("addRole")]
        public async Task<IActionResult> AddRole([FromBody] RoleRequestDto role)
        {
            if (ModelState.IsValid)
            {
                var Role = new IdentityRole()
                {
                    Name = role.RoleName,
                };
                var Role_exist = await _RoleManager.RoleExistsAsync(Role.Name);
                if (Role_exist)
                {
                    return BadRequest("Role exist");
                }

                var is_created = await _RoleManager.CreateAsync(Role);
                if (is_created.Succeeded)
                {
                    //Add Token 
                    return Ok("Role created");

                }
                else
                {
                    List<string> errors = new List<string>();
                    foreach (var error in is_created.Errors)
                    {
                        errors.Add(error.Code + error.Description);
                    }

                    return BadRequest(errors);

                }
            }
            return BadRequest();
        }
        ///------------ Register methode with jwtToken with Authorize control to superuser
        [HttpPost]
        [Route("RegisterEmployer")]
        ///here you set your application restrictions Roles identifies the users that can access your methode
        ///and you specifie that it uses JwtBearer token
        // [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme,Roles = "superuser")]
        public async Task<IActionResult> RegisterEmployer([FromBody] EmployerInfoDto user)
        {
            if (user != null)
            {
                //create new instance of the Users table model
                var new_user = new employer3()
                {
                    UserName = user.Name,
                    Email = user.Email,
                    EmailConfirmed = false

                };
                authResult is_created;
                if (user.Role == "employer")
                {
                    is_created = await _authentificationService.is_usercreated(user);
                }
                else
                {
                    return BadRequest(new authResult()
                    {
                        Result = false,
                        Errors = new List<string>()
                        {
                            "Role does not match"
                        }
                    });

                }

                if (!is_created.Result)
                {
                    return BadRequest(is_created);

                }
                else
                {
                    // add Employer information to database 
                    await _authentificationService.RegisterEmployer(user);
                    // Find user by Email
                    var createdUser = await _usermanager.FindByEmailAsync(new_user.Email);
                    // add User Role
                    await _usermanager.AddToRoleAsync(createdUser, user.Role);

                    try
                    {
                        //custom code de confirmation   
                        var code = await _usermanager.GenerateEmailConfirmationTokenAsync(createdUser);
                        // email link to

                        var confirmationUrl = Request.Scheme + "://" + Request.Host + @Url.Action("ConfirmEmail", "Authentification", new { email = new_user.Email, code });
                        //setting the email message
                        var emailBody = "<h1 style='color:#4CAF50'>Dear User</h1>" +
                            "<p>Thank you for signing up for our service. To complete the registration process, we need to verify your account.</p>" +
                            "<p> Please click on the link below to verify your email address and activate your account:</p>" +
                            "<p style='font-size:medium;'>code : " + "</p>" +
                            "<a style='background:#4CAF50;padding: 15px 32px; text-align: center; text-decoration: none;display: inline-block;font-size: 16px;margin: 4px 2px; cursor: pointer;color:white; 'href=" + System.Text.Encodings.Web.HtmlEncoder.Default.Encode(confirmationUrl) + ">Verification Link</a>" +
                            "<p>Once you've verified your account, you'll be able to start using our service right away. If you have any questions or concerns, please don't hesitate to contact our customer support team.</p>" +
                            "<p>Thank you for choosing our service!<p>";

                        EmailHelperSMTP emailHelper = new EmailHelperSMTP();

                        bool emailResponse = emailHelper.SendEmail(new_user.Email, emailBody);
                        if (emailResponse)
                        {
                            return Ok(new Response { Status = "Almost Done", Message = "Email Need Confirmation " });
                        }
                        return BadRequest(
                           "Log email failed"
                        );
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine(ex);
                    }


                }


            }

            return BadRequest("bad");

        }





        [HttpPost]
        [Route("RegisterShopowner")]
        ///here you set your application restrictions Roles identifies the users that can access your methode
        ///and you specifie that it uses JwtBearer token
        // [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme,Roles = "superuser")]
        public async Task<IActionResult> RegisterShopowner([FromBody] shopownerDto user)
        {
            if (user != null)
            {
                //create new instance of the Users table model
                var new_user = new employer3()
                {
                    UserName = user.Name,
                    Email = user.Email,
                    EmailConfirmed = false

                };
                authResult is_created;
                if (user.Role == "shopowner")
                {
                    is_created = await _authentificationService.is_usercreated(user);
                }
                else
                {
                    return BadRequest(new authResult()
                    {
                        Result = false,
                        Errors = new List<string>()
                        {
                            "Role does not match"
                        }
                    });

                }
                if (!is_created.Result)
                {
                    return BadRequest(is_created);

                }
                else
                {
                    // add Employer information to database 
                    await _authentificationService.RegisterShopowner(user);
                    // Find user by Email
                    var createdUser = await _usermanager.FindByEmailAsync(new_user.Email);
                    // add User Role
                    await _usermanager.AddToRoleAsync(createdUser, user.Role);

                    try
                    {
                        //custom code de confirmation   
                        var code = await _usermanager.GenerateEmailConfirmationTokenAsync(createdUser);
                        // email link to

                        var confirmationUrl = Request.Scheme + "://" + Request.Host + @Url.Action("ConfirmEmail", "Authentification", new { email = new_user.Email, code });
                        //setting the email message
                        var emailBody = "<h1 style='color:#4CAF50'>Dear User</h1>" +
                            "<p>Thank you for signing up for our service. To complete the registration process, we need to verify your account.</p>" +
                            "<p> Please click on the link below to verify your email address and activate your account:</p>" +
                            "<p style='font-size:medium;'>code : " + "</p>" +
                            "<a style='background:#4CAF50;padding: 15px 32px; text-align: center; text-decoration: none;display: inline-block;font-size: 16px;margin: 4px 2px; cursor: pointer;color:white; 'href=" + System.Text.Encodings.Web.HtmlEncoder.Default.Encode(confirmationUrl) + ">Verification Link</a>" +
                            "<p>Once you've verified your account, you'll be able to start using our service right away. If you have any questions or concerns, please don't hesitate to contact our customer support team.</p>" +
                            "<p>Thank you for choosing our service!<p>";

                        EmailHelperSMTP emailHelper = new EmailHelperSMTP();

                        bool emailResponse = emailHelper.SendEmail(new_user.Email, emailBody);
                        if (emailResponse)
                        {
                            return Ok(new Response { Status = "Almost Done", Message = "Email Need Confirmation " });
                        }
                        return BadRequest(
                           "Log email failed"
                        );
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine(ex);
                    }


                }


            }

            return BadRequest("bad");

        }


        [HttpPost]
        [Route("RegisterEmployee")]
        ///here you set your application restrictions Roles identifies the users that can access your methode
        ///and you specifie that it uses JwtBearer token
        //[Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme,Roles = "employer")]
        public async Task<IActionResult> RegisterEmployee([FromBody] EmployeeDto user)
        {
            if (user != null)
            {
                //create new instance of the Users table model
                var new_user = new employer3()
                {
                    UserName = user.Name,
                    Email = user.Email,
                    EmailConfirmed = false

                };
                authResult is_created;
                if (user.Role == "employee")
                {
                    is_created = await _authentificationService.is_usercreated(user);
                }
                else
                {
                    return BadRequest(new authResult()
                    {
                        Result = false,
                        Errors = new List<string>()
                        {
                            "Role does not match"
                        }
                    });

                }

                if (!is_created.Result)
                {
                    return BadRequest(is_created);

                }
                else
                {
                    // add Employer information to database 
                    await _authentificationService.RegisterEmployee(user);
                    // Find user by Email
                    var createdUser = await _usermanager.FindByEmailAsync(new_user.Email);
                    // add User Role
                    await _usermanager.AddToRoleAsync(createdUser, user.Role);

                    try
                    {
                        //custom code de confirmation   
                        var code = await _usermanager.GenerateEmailConfirmationTokenAsync(createdUser);
                        // email link to

                        var confirmationUrl = Request.Scheme + "://" + Request.Host + @Url.Action("ConfirmEmail", "Authentification", new { email = new_user.Email, code });
                        //setting the email message
                        var emailBody = "<h1 style='color:#4CAF50'>Dear User</h1>" +
                            "<p>Thank you for signing up for our service. To complete the registration process, we need to verify your account.</p>" +
                            "<p> Please click on the link below to verify your email address and activate your account:</p>" +
                            "<p style='font-size:medium;'>code : "  + "</p>" +
                            "<a style='background:#4CAF50;padding: 15px 32px; text-align: center; text-decoration: none;display: inline-block;font-size: 16px;margin: 4px 2px; cursor: pointer;color:white; 'href=" + System.Text.Encodings.Web.HtmlEncoder.Default.Encode(confirmationUrl) + ">Verification Link</a>" +
                            "<p>Once you've verified your account, you'll be able to start using our service right away. If you have any questions or concerns, please don't hesitate to contact our customer support team.</p>" +
                            "<p>Thank you for choosing our service!<p>";

                        EmailHelperSMTP emailHelper = new EmailHelperSMTP();

                        bool emailResponse = emailHelper.SendEmail(new_user.Email, emailBody);
                        if (emailResponse)
                        {
                            return Ok(new Response { Status = "Almost Done", Message = "Email Need Confirmation " });
                        }
                        return BadRequest(
                           "Log email failed"
                        );
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine(ex);
                    }


                }


            }

            return BadRequest("bad");

        }

        [HttpPost]
        [Route("RegisterSuperuser")]
        ///here you set your application restrictions Roles identifies the users that can access your methode
        ///and you specifie that it uses JwtBearer token
        // [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme,Roles = "superuser")]
        public async Task<IActionResult> RegisterSuperuser([FromBody] UserRegistrationRequestDto user)
        {
            if (user != null)
            {
                //create new instance of the Users table model
                var new_user = new employer3()
                {
                    UserName = user.Name,
                    Email = user.Email,
                    EmailConfirmed = false

                };
                authResult is_created;
                if (user.Role == "superuser")
                {
                    is_created = await _authentificationService.is_usercreated(user);
                }
                else
                {
                    return BadRequest(new authResult()
                    {
                        Result = false,
                        Errors = new List<string>()
                        {
                            "Role does not match"
                        }
                    });

                }
                if (!is_created.Result)
                {
                    return BadRequest(is_created);

                }
                else
                {
                    // Find user by Email
                    var createdUser = await _usermanager.FindByEmailAsync(new_user.Email);
                    // add User Role
                    await _usermanager.AddToRoleAsync(createdUser, user.Role);

                    try
                    {
                        //custom code de confirmation   
                        var code = await _usermanager.GenerateEmailConfirmationTokenAsync(createdUser);
                        // email link to

                        var confirmationUrl = Request.Scheme + "://" + Request.Host + @Url.Action("ConfirmEmail", "Authentification", new { email = new_user.Email, code });
                        //setting the email message
                        var emailBody = "<h1 style='color:#4CAF50'>Dear User</h1>" +
                            "<p>Thank you for signing up for our service. To complete the registration process, we need to verify your account.</p>" +
                            "<p> Please click on the link below to verify your email address and activate your account:</p>" +
                            "<p style='font-size:medium;'>code : " + code + "</p>" +
                            "<a style='background:#4CAF50;padding: 15px 32px; text-align: center; text-decoration: none;display: inline-block;font-size: 16px;margin: 4px 2px; cursor: pointer;color:white; 'href=" + System.Text.Encodings.Web.HtmlEncoder.Default.Encode(confirmationUrl) + ">Verification Link</a>" +
                            "<p>Once you've verified your account, you'll be able to start using our service right away. If you have any questions or concerns, please don't hesitate to contact our customer support team.</p>" +
                            "<p>Thank you for choosing our service!<p>";

                        EmailHelperSMTP emailHelper = new EmailHelperSMTP();

                        bool emailResponse = emailHelper.SendEmail(new_user.Email, emailBody);
                        if (emailResponse)
                        {
                            return Ok(new Response { Status = "Almost Done", Message = "Email Need Confirmation " });
                        }
                        return BadRequest(
                           "Log email failed"
                        );
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine(ex);
                    }


                }


            }

            return BadRequest("bad");

        }

        /// ----------------confirm email

        [HttpGet]
        [Route("ConfirmEmail")]
        public async Task<IActionResult> ConfirmEmail(string email, string code)
        {
            if (email == null || code == null)
            {
                return BadRequest(new authResult()
                {
                    Errors = new List<string>()
              {
                  "Invalid email confirmation url"
              }
                });
            }
            var user = await _usermanager.FindByEmailAsync(email);
            if (user == null)
            {
                return BadRequest(new authResult()
                {
                    Errors = new List<string>()
              {
                  "Invalid email param"
              }
                });
            }
            IdentityResult is_confirmed = await _usermanager.ConfirmEmailAsync(user, code);
            if (is_confirmed.Succeeded)
            {
                user.EmailConfirmed = true;
                await _usermanager.UpdateAsync(user);
                return Ok("Thank you for confirming your mail");

            }
            else
            {
                return BadRequest(new authResult()
                {
                    Result = false,
                    Errors = new List<string>()
                    {
                        "code incorrect"
                    }
                });
            }

        }


        ///------------ Login methode with jwtToken 
        [HttpPost]
        [Route("login")]
        [AllowAnonymous]
        public async Task<IActionResult> Login([FromBody] UserLoginRequestDto user)
        {
            if (ModelState.IsValid)
            {
                var user_exist = await _usermanager.FindByEmailAsync(user.Email);

                if (user_exist == null)
                    return BadRequest(new authResult()
                    {
                        Errors = new List<string>(){
                        "user does not exist "
                    },
                        Result = false
                    });
                if (!user_exist.EmailConfirmed)
                {
                    return BadRequest(new authResult()
                    {
                        Errors = new List<string>(){
                        "email need confirmation "
                    },
                        Result = false
                    });
                }

                var isCorrect = await _usermanager.CheckPasswordAsync(user_exist, user.Password);

                if (isCorrect)
                {
                    var jwtToken = await GenerateJwtToken(user_exist);
                    return Ok(jwtToken);
                }
                else
                {
                    return BadRequest(new authResult()
                    {
                        Result = false,
                        Errors = new List<string>(){
                        "Password incorrect "
                    }
                    });
                }
            }
            return BadRequest();
        }

        ///------------ get users Roles
        [HttpGet]
        [Route("GetUsersRoles")]
        public async Task<IActionResult> GetUsersRoutes(string email)
        {

            var user = await _usermanager.FindByEmailAsync(email);
            if (user == null)
            {
                return BadRequest(new
                {
                    error = "User does not exist "
                });
            }
            var Roles = await _usermanager.GetRolesAsync(user);
            return Ok(Roles);
        }

        ///------------ Generate jwt token 
        private async Task<authResult> GenerateJwtToken(employer3 user)
        {
            var JwtTokenHandler = new JwtSecurityTokenHandler();
            var claims = await _authentificationService.GetClaims(user);
            var key = Encoding.UTF8.GetBytes(_configuration.GetSection("JwtConfig:secret").Value);
            var TokenDescription = new SecurityTokenDescriptor()
            {
                Subject = new ClaimsIdentity(claims),
                Expires = DateTime.UtcNow.Add(TimeSpan.Parse(_configuration.GetSection("JwtConfig:ExpiryTimeFrame").Value)),
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256)

            };
            Console.Write(_usermanager.GetRolesAsync(user));
            var token = JwtTokenHandler.CreateToken(TokenDescription);
            var JwtToken = JwtTokenHandler.WriteToken(token);
            var RefreshToken = new RefreshTokenModel()
            {
                Id = Guid.NewGuid().ToString(),
                JwtId = token.Id,
                Token = GenerateCode(23),
                AddedDate = DateTime.UtcNow,
                ExpiryDate = DateTime.UtcNow.AddMonths(6),
                IsRevoked = false,
                IsUsed = false,
                UserId = user.Id
            };
            await _context.RefreshTokenTable.AddAsync(RefreshToken);
            await _context.SaveChangesAsync();
            return new authResult()
            {
                Token = JwtToken,
                RefreshToken = RefreshToken.Token,
                Result = true
            };
        }

        private string GenerateCode(int length)
        {
            var random = new Random();
            var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ123456789";
            return new string(Enumerable.Repeat(chars, length).Select(s => s[random.Next(s.Length)]).ToArray());
        }

        [HttpPost]
        [Route("/RefreshToken")]
        public async Task<IActionResult> RefreshToken([FromBody] RefreshTokenDto refreshTokenDto)
        {
            if (ModelState.IsValid)
            {
                var result = VerifyAndGeneratetoken(refreshTokenDto);
                if (result == null)
                    return BadRequest(new authResult()
                    {
                        Errors = new List<string>()
                {
                    "invalid tokens"
                },
                        Result = false
                    });
                return Ok(result);
            }
            return BadRequest(new authResult()
            {
                Errors = new List<string>()
                {
                    "invalid parameters"
                },
                Result = false
            });
        }
        private async Task<authResult> VerifyAndGeneratetoken(RefreshTokenDto refreshTokenDto)
        {
            var jwtTokenHandler = new JwtSecurityTokenHandler();

            try
            {
                _tokenValidationParams.ValidateLifetime = false;
                var tokenInVerification = jwtTokenHandler.ValidateToken(refreshTokenDto.Token, _tokenValidationParams, out var validatedToken);
                if (validatedToken is JwtSecurityToken jwtSecurityToken)
                {
                    var result = jwtSecurityToken.Header.Alg.Equals(SecurityAlgorithms.HmacSha256, StringComparison.InvariantCultureIgnoreCase);
                    if (result == false)
                        return null;
                }

                var utcExpiryDate = long.Parse(tokenInVerification.Claims.FirstOrDefault(x => x.Type == JwtRegisteredClaimNames.Exp).Value);

                var expiryDate = UnixTimeStampToDateTime(utcExpiryDate);
                if (expiryDate <= DateTime.Now)
                {
                    return new authResult()
                    {
                        Result = false,
                        Errors = new List<string>()
                        {
                            "Expired token "
                        }
                    };
                }

                var storedToken = await _context.RefreshTokenTable.FirstOrDefaultAsync(x => x.Token == refreshTokenDto.Token);
                if (storedToken == null)
                    return new authResult()
                    {
                        Result = false,
                        Errors = new List<string>() {
                            "Invalid token "
                        }
                    };

                if (storedToken.IsUsed)
                    return new authResult()
                    {
                        Result = false,
                        Errors = new List<string>() {
                            "Invalid token "
                        }
                    };

                if (storedToken.IsRevoked)

                    return new authResult()
                    {
                        Result = false,
                        Errors = new List<string>() {
                            "Invalid token "
                        }
                    };

                var jti = tokenInVerification.Claims.FirstOrDefault(x => x.Type == JwtRegisteredClaimNames.Jti).Value;
                if (storedToken.JwtId != jti)
                    return new authResult()
                    {
                        Result = false,
                        Errors = new List<string>() {
                            "Invalid token "
                        }
                    };

                if (storedToken.ExpiryDate < DateTime.UtcNow)
                    return new authResult()
                    {
                        Result = false,
                        Errors = new List<string>() {
                            "Expired tokens "
                        }
                    };

                storedToken.IsUsed = true;
                _context.RefreshTokenTable.Update(storedToken);
                await _context.SaveChangesAsync();
                var dbUser = await _usermanager.FindByIdAsync(storedToken.UserId);
                return await GenerateJwtToken(dbUser);

            }
            catch (Exception)
            {

                return new authResult()
                {
                    Result = false,
                    Errors = new List<string>() {
                            "Server error "
                        }
                };
            }
        }
        private DateTime UnixTimeStampToDateTime(long unixTimeStamp)
        {
            var dateTimeVal = new DateTime(1970, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc);
            dateTimeVal = dateTimeVal.AddSeconds(unixTimeStamp).ToUniversalTime();
            return dateTimeVal;
        }


        [HttpPost("changepassword")]
        public async Task<IActionResult> ChangePassword([FromBody] ChangePasswordViewModel model)
        {
            var user = await _usermanager.FindByNameAsync(model.Username);

            if (user == null)
            {
                return StatusCode(StatusCodes.Status404NotFound, new Response { Status = "Error", Message = "Username does not Exist" });
            }
            if (string.Compare(model.NewPassword, model.ConfirmNewPassword) != 0)
                return StatusCode(StatusCodes.Status400BadRequest, new Response { Status = "Error", Message = "UNewPassword and ConfirmePassword not Match" });

            var result = await _usermanager.ChangePasswordAsync(user, model.CurrentPassword, model.NewPassword);

            if (!result.Succeeded)
            {
                var errors = new List<string>();
                foreach (var error in result.Errors)
                {
                    errors.Add(error.Description);
                }

                return StatusCode(StatusCodes.Status500InternalServerError, new Response { Status = "Error", Message = string.Join(",", errors) });
            }
            return Ok(new Response { Status = "Success", Message = "Password Seccessfully Changed" });

        }



        [HttpPost]
        [AllowAnonymous]
        [Route("SendPasswordResetCode")]
        public async Task<IActionResult> SendPasswordResetCode(ForgotPasswordViewModel email)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            // Get Identity User details user user manager
            var user = await _usermanager.FindByEmailAsync(email.Email);
            if (user == null)
            {
                return NotFound("Email Doesn't Exist");
            }

            // Generate password reset token
            var token = await _usermanager.GeneratePasswordResetTokenAsync(user);

            // Generate OTP
            int otp = RandomNumberGeneartor.Generate(100000, 999999);

            var resetPassword = new ResetPassword()
            {
                Email = email.Email,
                OTP = otp.ToString(),
                Token = token,
                UserId = user.Id,




                InsertDateTimeUTC = DateTime.UtcNow
            };

            // Save data into db with OTP
            await _context.AddAsync(resetPassword);
            await _context.SaveChangesAsync();

            // to do: Send token in email
            var emailBody = "<h1 style='color:#4CAF50'>Dear User</h1>" +

                    "<p> You can use this code to <u>Restore your</u> password :</p>" +
                    "<p style='font-size:medium;'>code : " + otp + "</p>" +

                    "<p>Thank you for choosing our service!<p>";

            EmailHelperSMTP emailHelper = new EmailHelperSMTP();

            bool emailResponse = emailHelper.SendEmail(email.Email, emailBody);
            if (emailResponse)
            {
                return StatusCode(StatusCodes.Status200OK,
                 new Response { Status = "Success", Message = "Code Was Send To " + email.Email + " Check Your Inbox " });
            }
            return StatusCode(StatusCodes.Status400BadRequest,
               new Response { Status = "Error", Message = "Plaese Try Again !!" });
        }




        [HttpPost]
        [AllowAnonymous]
        [Route("Verifotp")]
        public async Task<IActionResult> VerifOTP(VerifOTP model)
        {
            if (string.IsNullOrEmpty(model.Email))
            {

                return StatusCode(StatusCodes.Status400BadRequest,
              new Response { Status = "Error", Message = "Email & New Password should not be null or empty !!" });
            }

            // Get Identity User details user user manager
            var user = await _usermanager.FindByEmailAsync(model.Email);



            // getting token from otp
            var resetPasswordDetails = await _context.ResetPassword
                .Where(rp => rp.OTP == model.OTP)
                .OrderByDescending(rp => rp.InsertDateTimeUTC)
                .FirstOrDefaultAsync();
            if (resetPasswordDetails == null)
            {
                if (resetPasswordDetails == null)
                {
                    return StatusCode(StatusCodes.Status404NotFound,
                  new Response { Status = "Error", Message = "otp not matched  !!" });

                }
            }

            // Verify if token is older than 15 minutes
            var expirationDateTimeUtc = resetPasswordDetails.InsertDateTimeUTC.AddMinutes(15);


            if (expirationDateTimeUtc < DateTime.UtcNow)
            {

                return StatusCode(StatusCodes.Status400BadRequest,
              new Response { Status = "Error", Message = "OTP is expired, please generate the new OTP !!" });
            }

            /* var res = await _usermanager.ResetPasswordAsync(user, resetPasswordDetails.Token, newPassword);

              if (!res.Succeeded)
              {
                  return StatusCode(StatusCodes.Status400BadRequest,
                new Response { Status = "Error", Message = "Plaese Try Again !!" });
                  });*/


            return StatusCode(StatusCodes.Status200OK,
                new Response
                {
                    Status = "Success",
                    Message = "OTP catched  "
                });
        }

        [HttpPost]
        [AllowAnonymous]
        [Route("ResetPassword")]
        public async Task<IActionResult> ResetPassword(RestorePassword reset)
        {
            if (string.IsNullOrEmpty(reset.Email) || string.IsNullOrEmpty(reset.NewPassword))
            {

                return StatusCode(StatusCodes.Status500InternalServerError,
              new Response { Status = "Error", Message = "Email & New Password should not be null or empty !!" });
            }

            // Get Identity User details user user manager
            var user = await _usermanager.FindByEmailAsync(reset.Email);
            var token = await _usermanager.GeneratePasswordResetTokenAsync(user);
            if (user == null)
            {
                return StatusCode(StatusCodes.Status404NotFound, new Response { Status = "Error", Message = "Username does not Exist" });
            }



            var res = await _usermanager.ResetPasswordAsync(user, token, reset.NewPassword);

            if (!res.Succeeded)
            {
                return StatusCode(StatusCodes.Status400BadRequest,
              new Response { Status = "Error", Message = "Plaese Try Again !!" });
            }

            return StatusCode(StatusCodes.Status200OK,
                new Response
                {
                    Status = "Success",
                    Message = "Password Has Been Changed With Successfully "
                });
        }


        [HttpPut("updateemployeeNumTel")]
        public async Task<IActionResult> UpdateEmployeeNumtel(string? id, string? numtel)
        {
            var employee = await _context.Employee.FindAsync(id);
            if (employee != null && numtel != null)
            {
                if (employee.NumTel == numtel)
                {
                    return NotFound();
                }
                employee.NumTel = numtel;
                await _context.SaveChangesAsync();
                return Ok("Phone number updated");
            }
            else if (numtel == null)
            {
                return NotFound();
            }
            else
            {
                return NotFound();
            }
        }

        [HttpPut("updateemployeeUsername")]
        public async Task<IActionResult> UpdateEmployeeUsername(string? id, string? username)
        {
            var employee = await _context.Users.FindAsync(id);
            if (employee != null && username != null)
            {
                if (employee.UserName == username)
                {
                    return NotFound();
                }
                employee.UserName = username;
                await _context.SaveChangesAsync();
                return Ok("Username updated");
            }
            else if (username == null)
            {
                return NotFound();
            }
            else
            {
                return NotFound();
            }
        }



        /*__________________________ Update cashier adresse ______________________________________________*/
        [HttpPut("updateCashierAdresse")]
        public async Task<IActionResult> UpdateCashierAdresse(string? id, string? adresse)
        {
            var cashier = await _context.Cassier.FindAsync(id);
            if (cashier == null)
            {
                return NotFound();
            }

            if (string.IsNullOrWhiteSpace(adresse) || string.Equals(adresse, cashier.adresse))
            {
                return NotFound();
            }

            cashier.adresse = adresse;
            await _context.SaveChangesAsync();

            return Ok("Address updated");
        }

        /*__________________________ End Update cashier adresse _________________________________________*/

        /*[HttpPut("updatebalance")]*/
       /*  public async Task<IActionResult> UpdateBalance(string? idemployee , string? idcashier, double value) */
        /*{*/
            /*var employee = await _context.Employee.FindAsync(idemployee);*/
           /* if (employee == null)*/
            /*{*/
               /* return NotFound("Employee not found");*/
            /*}*/

           /* var cashier = await _context.Cassier.FindAsync(idcashier);*/
            /*if (cashier == null)*/
           /* {*/
               /* return BadRequest("Cashier not found");*/
            /*}*/

           /* if (employee.balance < value)*/
            /*{*/
               /* return BadRequest("Insufficient balance");*/
            /*}*/

           /* employee.balance -= value;*/
            /*cashier.balance += value;*/

           /* await _context.SaveChangesAsync();*/

           /* return Ok("Balance updated");*/
       /* }*/


        /*_______________________________Register Cashier________________________________________________*/
        [HttpPost]
        [Route("RegisterCasier")]
        ///here you set your application restrictions Roles identifies the users that can access your methode
        ///and you specifie that it uses JwtBearer token
        //[Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme,Roles = "employer")]
        public async Task<IActionResult> RegisterCashier([FromBody] CassierDto user)
        {
            if (user != null)
            {
                //create new instance of the Users table model
                var new_user = new employer3()
                {
                    UserName = user.Name,
                    Email = user.Email,
                    EmailConfirmed = false

                };
                authResult is_created;
                if (user.Role == "cashier")
                {
                    is_created = await _authentificationService.is_usercreated(user);
                }
                else
                {
                    return BadRequest(new authResult()
                    {
                        Result = false,
                        Errors = new List<string>()
                        {
                            "Role does not match"
                        }
                    });

                }

                if (!is_created.Result)
                {
                    return BadRequest(is_created);

                }
                else
                {
                    // add Employer information to database 
                    await _authentificationService.RegisterCasier(user);
                    // Find user by Email
                    var createdUser = await _usermanager.FindByEmailAsync(new_user.Email);
                    // add User Role
                    await _usermanager.AddToRoleAsync(createdUser, user.Role);

                    try
                    {
                        //custom code de confirmation   
                        var code = await _usermanager.GenerateEmailConfirmationTokenAsync(createdUser);
                        // email link to

                        var confirmationUrl = Request.Scheme + "://" + Request.Host + @Url.Action("ConfirmEmail", "Authentification", new { email = new_user.Email, code });
                        //setting the email message
                        var emailBody = "<h1 style='color:#4CAF50'>Dear User</h1>" +
                            "<p>Thank you for signing up for our service. To complete the registration process, we need to verify your account.</p>" +
                            "<p> Please click on the link below to verify your email address and activate your account:</p>" +
                            "<p style='font-size:medium;'>code : " + "</p>" +
                            "<a style='background:#4CAF50;padding: 15px 32px; text-align: center; text-decoration: none;display: inline-block;font-size: 16px;margin: 4px 2px; cursor: pointer;color:white; 'href=" + System.Text.Encodings.Web.HtmlEncoder.Default.Encode(confirmationUrl) + ">Verification Link</a>" +
                            "<p>Once you've verified your account, you'll be able to start using our service right away. If you have any questions or concerns, please don't hesitate to contact our customer support team.</p>" +
                            "<p>Thank you for choosing our service!<p>";

                        EmailHelperSMTP emailHelper = new EmailHelperSMTP();

                        bool emailResponse = emailHelper.SendEmail(new_user.Email, emailBody);
                        if (emailResponse)
                        {
                            return Ok(new Response { Status = "Almost Done", Message = "Email Need Confirmation " });
                        }
                        return BadRequest(
                           "Log email failed"
                        );
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine(ex);
                    }


                }


            }

            return BadRequest("bad");

        }
        /*______________________________ End Register Cashier _________________________________________*/
    }
}