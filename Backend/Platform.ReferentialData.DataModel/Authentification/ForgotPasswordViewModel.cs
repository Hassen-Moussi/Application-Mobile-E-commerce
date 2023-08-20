using System.ComponentModel.DataAnnotations;

namespace Platform.ReferencialData.WebAPI.Controllers.Authentification
{
    public class ForgotPasswordViewModel
    {
        [Required]
        [EmailAddress]
        public string Email { get; set; }
    }
}