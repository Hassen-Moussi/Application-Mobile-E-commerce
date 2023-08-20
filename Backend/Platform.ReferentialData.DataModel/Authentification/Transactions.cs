using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Platform.ReferentialData.DataModel.Authentification
{
    public class Transactions
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public string Id { get; set; }
        public string? Cashierid { get; set; }
        public string Name { get; set; }
        public double prix { get; set; }
        public DateTimeOffset datecreation { get; set; }
        public string? Employeeid { get; set; }
        public int isScanned { get; set; } = 0;
    }

}
