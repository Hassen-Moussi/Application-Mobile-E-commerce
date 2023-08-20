using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Platform.ReferentialData.DataModel.Authentification
{
    public class RestorePassword
    {
        public string Email { get; set; }
        [Required]
        public string NewPassword { get; set; }
    }
}
