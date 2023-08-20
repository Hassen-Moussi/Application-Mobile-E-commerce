using login.models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Platform.ReferentialData.DataModel.Authentification
{
   public class Cassier
    {
        [Key]
        public string CasierId { get; set; }
        public ICollection<Employee> employee { get; set; } = null;
        public string moreInfoId { get; set; }
        public employer3 cassier { get; set; }
        public string adresse { get; set; }
        public double balance { get; set; }
        public employer3 employer { get; set; }
    }
}
