using System.Text;
using login.data.PostgresConn;
using login.jwt.config;
using login.models;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc.Authorization;
using Microsoft.AspNetCore.Mvc.Controllers;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Platform.ReferencialData.Business.business_services.Authentification;
using Platform.ReferencialData.Business.business_services.EmployeeManagement;
using Platform.ReferencialData.Business.business_services_implementations.Authentification;
using Platform.ReferencialData.Business.business_services_implementations.EmployeeManagement;

var builder = WebApplication.CreateBuilder(args);

//add Policy
/*builder.Services.AddMvc(options =>
{
    var policy = new AuthorizationPolicyBuilder()
        .RequireAuthenticatedUser()
        .Build();

    options.Filters.Add(new AuthorizeFilter(policy));
});

*/

builder.Services.AddAuthorization(options =>
{
    options.AddPolicy("createManagerRH", policy =>
    {
        policy.RequireClaim("Permission", "createManagerRH");
    });
    options.AddPolicy("createManagerFacturation", policy =>
    {
        policy.RequireClaim("Permission", "createManagerFacturation");
    });
    options.AddPolicy("createEmployee", policy =>
    {
        policy.RequireClaim("Permission", "createEmployee");
    });
    options.AddPolicy("refillAllWallet", policy =>
    {
        policy.RequireClaim("Permission", "refillAllWallet");
    });
    options.AddPolicy("refillWallet", policy =>
    {
        policy.RequireClaim("Permission", "refillWallet");
    });
    options.AddPolicy("accessHistorieFromEmployerToEmployee", policy =>
    {
        policy.RequireClaim("Permission", "accessHistorieFromEmployerToEmployee");
    });
    options.AddPolicy("accessHistorieFromDynoToEmployer", policy =>
    {
        policy.RequireClaim("Permission", "accessHistorieFromDynoToEmployer");
    });
    options.AddPolicy("refillEmployerWallet", policy =>
    {
        policy.RequireClaim("Permission", "refillEmployerWallet");
    });
});

// Add services to the container.

builder.Services.AddScoped<IAuthentificationService, AuthentificationService>();
builder.Services.AddScoped<IEmployeeManagementService, EmployeeManagementService>();
builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();



builder.Services.AddEntityFrameworkNpgsql()
.AddDbContext<Postgres>(opt => opt.UseNpgsql(builder.Configuration.GetConnectionString("pgsqlconnection")));


builder.Services.Configure<JwtConfig>(builder.Configuration.GetSection("JwtConfig"));

var key = Encoding.ASCII.GetBytes(builder.Configuration.GetSection("JwtConfig:secret").Value);
var TokenValidationParameters = new TokenValidationParameters()
{
    ValidateIssuerSigningKey = true,
    IssuerSigningKey = new SymmetricSecurityKey(key),
    ValidateIssuer = false,
    ValidateAudience = false,
    RequireExpirationTime = false,
    ValidateLifetime = true

};
builder.Services.AddSingleton(TokenValidationParameters);
builder.Services.AddCors();
builder.Services.AddAuthentication(options => {
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddJwtBearer(jwt =>
{
    jwt.SaveToken = true;
    jwt.TokenValidationParameters = TokenValidationParameters;
});

builder.Services.AddIdentity<employer3, IdentityRole>(option => option.SignIn.RequireConfirmedEmail = true

).AddEntityFrameworkStores<Postgres>().AddDefaultTokenProviders(); ;


var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}


app.UseCors(builder =>
{
    builder
    .AllowAnyOrigin()
    .AllowAnyMethod()
    .AllowAnyHeader();
});

app.UseHttpsRedirection();
app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();
