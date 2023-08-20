using login.models;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Platform.ReferentialData.DataModel.Authentification;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Intrinsics.X86;

namespace Platform.ReferencialData.WebAPI.Controllers.Authentification
{

    public class ResetPassword
    {
        [Key]
        
        public int Id { get; set; }

        [StringLength(450)]
        public string UserId { get; set; }

        [StringLength(256)]
        public string Email { get; set; }

        [StringLength(5000)]
        public string Token { get; set; }

        [StringLength(10)]
        public string OTP { get; set; }

        public DateTime InsertDateTimeUTC { get; set; }

        


    }
}