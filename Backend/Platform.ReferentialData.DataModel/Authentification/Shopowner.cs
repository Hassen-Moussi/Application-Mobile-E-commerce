using login.models;
using Microsoft.AspNetCore.Identity;
using System.ComponentModel.DataAnnotations;

namespace WebApplication1.models
{
    public class ShopOwner
    {
        [Key]
        public string ShopOwnerIdMoreInfo { get; set; }
        public string codeTVA { get; set; }
        public string Adresse { get; set; }
        public string NumTel { get; set; }
        public string PaymentMethode { get; set; }
        public string adresseFacturation { get; set; }
        public string moreInfoId { get; set; }
        public employer3 employer { get; set; }
        public double balance { get; set; }
    }
}
