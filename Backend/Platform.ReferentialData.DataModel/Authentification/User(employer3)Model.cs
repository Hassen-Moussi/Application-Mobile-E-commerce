using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.AspNetCore.Identity;
using Platform.ReferentialData.DataModel.Authentification;
using WebApplication1.models;

namespace login.models
{
    public class employer3 :IdentityUser {

     
        public MoreInfoEmployer moreInfo {get;set;}
        public ShopOwner ShopOwnerMoreInfo { get; set; }
        public Employee EmployeeId { get; set; }  
    }
}