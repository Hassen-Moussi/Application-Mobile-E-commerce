using login.models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Platform.ReferentialData.DtoModel.Authentification
{
    [Keyless]
    public class EmployeeDto: UserRegistrationRequestDto
    {
        
        public string NumTel { get; set; }

        [DisplayFormat(DataFormatString = "{0:N2}")]
        public double balance { get; set; }
    }
}
