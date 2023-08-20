using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Platform.ReferentialData.DataModel.Authentification
{
    public class Chat
    {
        [Key]
        public int Id { get; set; }
        public string Employeeid { get; set; }
        public string Message { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}
