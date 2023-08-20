using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Platform.ReferentialData.DtoModel.Authentification

{
    public class EmployeeRoleRequestDto
    {
        [Required]
        public string RoleName { get; set; }
        [Required]
        public List<string> Permisson { get; set;}
    }

}