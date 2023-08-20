using login.data.PostgresConn;
using login.models;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Platform.ReferencialData.Business.business_services.EmployeeManagement;
using Platform.ReferentialData.DtoModel.Authentification;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace Platform.ReferencialData.Business.business_services_implementations.EmployeeManagement
{
    public class EmployeeManagementService : IEmployeeManagementService
    {
        private readonly Postgres _context;
        private readonly UserManager<employer3> _usermanager;
        private readonly IConfiguration _configuration;
        private readonly RoleManager<IdentityRole> _RoleManager;
        public EmployeeManagementService(UserManager<employer3> _usermanager, Postgres context, IConfiguration configuration, RoleManager<IdentityRole> roleManager)
        {
            this._usermanager = _usermanager;
            _context = context;
            _configuration = configuration;
            _RoleManager = roleManager;
        }

        public async Task<bool> AddRole(RoleRequestDto role)
        {
            if (role != null)
            {
                var Role = new IdentityRole()
                {
                    Name = role.RoleName,
                };
                var Role_exist = await _RoleManager.RoleExistsAsync(Role.Name);
                if (Role_exist)
                {
                    return false;
                }

                var is_created = await _RoleManager.CreateAsync(Role);
                if (is_created.Succeeded)
                {
                    //Add Token 
                    return true;

                }

            }
            return false;
        }

        public async Task<bool> addClaims(IdentityRole existing_Role, List<string> permissions)
        {
            foreach (var permission in permissions)
            {
                var is_created = await _RoleManager.AddClaimAsync(existing_Role, new Claim("Permission", permission));
                if (!is_created.Succeeded)
                {
                    return false;
                }
               
            }
            return true;
        }
    }
}
