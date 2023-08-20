using login.models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Platform.ReferentialData.DtoModel.Authentification
{
    public class CassierDto : UserRegistrationRequestDto
    {
        public string adresse { get; set; }
        public double balance { get; set; }
    }
}
