using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Platform.ReferentialData.DtoModel.Authentification;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Platform.ReferentialData.DtoModel.Authentification
{
    public class ChangePasswordViewModel

    {
        [Required(ErrorMessage = "UserName Is Required")]

        public string Username { get; set; }
        [Required(ErrorMessage = "CurrenrtPassword Is Required")]

        public string CurrentPassword { get; set; }
        [Required(ErrorMessage = "NewPassword Is Required")]

        public string NewPassword { get; set; }
        [Required(ErrorMessage = "ConfirmePassword Is Required")]

        public string ConfirmNewPassword { get; set; }
    }



}
