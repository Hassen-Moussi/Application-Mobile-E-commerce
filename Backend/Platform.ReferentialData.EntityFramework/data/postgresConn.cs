using login.models;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Npgsql;
using Platform.ReferencialData.WebAPI.Controllers.Authentification;
using Platform.ReferentialData.DataModel.Authentification;
using Platform.ReferentialData.DtoModel.Authentification;
using System.Reflection.Emit;
using WebApplication1.models;

namespace login.data.PostgresConn
{
    public  class Postgres :IdentityDbContext<employer3> {
        public virtual DbSet<employer3> Employer3 { get; set; }
        public virtual DbSet<EmployeeDto> EmployeeDtos { get; set; }
        public virtual DbSet<MoreInfoEmployer> Employer {get;set;}
        public virtual DbSet<ShopOwner> Shopowner { get; set; }
        public virtual DbSet<RefreshTokenModel> RefreshTokenTable {get;set;}
        public virtual DbSet<Employee> Employee{ get; set;}
        public virtual DbSet<Employment> Employement { get; set; }
        public virtual DbSet<Categorie> categorie { get; set; }
        public virtual DbSet<Ticket> Ticket { get; set; }
        public virtual DbSet<Transactions> Transactions { get; set; }
        public virtual DbSet<Chat> Chat { get; set; }
        public virtual DbSet<Cassier> Cassier { get; set; }
        public virtual DbSet<shopownerHistorique> shopownerHistorique { get; set; }
        public virtual DbSet<Employeebalancehistrique> Employeebalancehistrique { get; set; }
        public virtual DbSet<MoreInfoEmployer> MoreInfoEmployer { get; set; }
        public object EmployeeDto { get; set; }
        public DbSet<ResetPassword> ResetPassword { get; set; }

        public Postgres(DbContextOptions<Postgres> options):base(options){
             
        }

        protected override void OnModelCreating(ModelBuilder model){
            base.OnModelCreating(model);
            model.Entity<employer3>(entity => 
                entity.HasOne(E=> E.moreInfo)
                .WithOne(M => M.employer)
                .HasForeignKey<MoreInfoEmployer>(m => m.moreInfoId)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("Fk_USER_MoreInfo")
            );
            model.Entity<employer3>(entity =>
              entity.HasOne(E => E.ShopOwnerMoreInfo)
              .WithOne(M => M.employer)
              .HasForeignKey<ShopOwner>(m => m.moreInfoId)
              .OnDelete(DeleteBehavior.Restrict)
              .HasConstraintName("Fk_USER_ShopMoreInfo")
          );
            model.Entity<employer3>(entity =>
           entity.HasOne(E => E.EmployeeId)
           .WithOne(M => M.employer)
           .HasForeignKey<Employee>(m => m.moreInfoId)
           .OnDelete(DeleteBehavior.Restrict)
           .HasConstraintName("Fk_USER_Employee")
       );

            model.Entity<Employment>()
            .HasKey(e => new { e.IdEmployee, e.IdEmployer});

            model.Entity<Employment>()
               .HasOne(s => s.employee)
               .WithMany(c => c.employment)
               .HasForeignKey(s => s.IdEmployee);
               
            model.Entity<Employment>()
               .HasOne(s => s.employer)
               .WithMany(c => c.employment)
               .HasForeignKey(s => s.IdEmployer);

            model.Entity<Employment>()
               .HasOne(s => s.Categorie)
               .WithMany(c => c.Employment)
               .HasForeignKey(s => s.IdCategorie);
            model.Entity<Categorie>()
               .HasOne(s => s.ticket)
               .WithOne(c => c.categorie)
               .HasForeignKey<Categorie>(s => s.idticket);

        }

      
    }
}