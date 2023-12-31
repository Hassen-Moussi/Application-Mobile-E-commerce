﻿using login.models;
using Microsoft.AspNetCore.Identity;
using Org.BouncyCastle.Asn1.Ocsp;
using Platform.ReferentialData.DtoModel.Authentification;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace Platform.ReferencialData.Business.business_services.Authentification
{
    public interface IAuthentificationService
    {
        Task<authResult> is_usercreated(UserRegistrationRequestDto user);
        Task RegisterShopowner(shopownerDto user);
        Task RegisterEmployee(EmployeeDto employee);
        Task RegisterEmployer(EmployerInfoDto user);
        Task<string> GenerateJwtToken(employer3 user);
        Task<List<Claim>> GetClaims(employer3 user);
        object GetUserAsync(string id);
        Task RegisterCasier(CassierDto cassier);
    }
}
