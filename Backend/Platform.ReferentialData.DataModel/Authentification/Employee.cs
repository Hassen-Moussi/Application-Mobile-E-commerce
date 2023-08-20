using login.models;
using Platform.ReferentialData.DataModel.Authentification;
using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;

namespace Platform.ReferentialData.DataModel.Authentification
{
    public class Employee 
    {
        [Key]
        public string EmployeeId { get; set; }
        public string NumTel { get; set; }

        [DisplayFormat(DataFormatString = "{0:N2}")]
        public double balance { get; set; }
        public List<Employment> employment  { get; set; }
        public string moreInfoId { get; set; }
        public employer3 employer { get; set; }
    }
}
