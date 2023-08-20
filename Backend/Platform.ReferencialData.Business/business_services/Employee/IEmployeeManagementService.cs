using login.models;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Platform.ReferentialData.DtoModel.Authentification;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Platform.ReferencialData.Business.business_services.EmployeeManagement
{
    public interface IEmployeeManagementService
    {
        Task<bool> AddRole(RoleRequestDto role);
        Task<bool> addClaims(IdentityRole existing_Role, List<string> permissions);
    }
}
