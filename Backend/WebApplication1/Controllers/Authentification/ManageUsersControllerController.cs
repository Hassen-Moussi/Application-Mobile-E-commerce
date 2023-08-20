using login.data.PostgresConn;
using login.models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Platform.ReferencialData.Business.business_services.Authentification;
using Platform.ReferentialData.DataModel.Authentification;
using System.Data;
using System.Security.Claims;
using WebApplication1.models;
using Microsoft.EntityFrameworkCore;


namespace Platform.ReferencialData.WebAPI.Controllers.Authentification

{
    [ApiController]
    [Route("[controller]")]
    public class ManageUsersController : ControllerBase
    {
        private readonly UserManager<employer3> _usermanager;
        private readonly RoleManager<IdentityRole> _RoleManager;
        private readonly IConfiguration _configuration;
        private readonly IAuthentificationService _authentificationService;
        private readonly Postgres _context;
        private ILogger _logger;
        private readonly IWebHostEnvironment _webHostEnvironment;

        public ManageUsersController(UserManager<employer3> _usermanager, RoleManager<IdentityRole> _RoleManager, IConfiguration _configuration, IAuthentificationService _authentificationService, Postgres _context, IWebHostEnvironment webHostEnvironment)
        {
            this._usermanager = _usermanager;
            this._configuration = _configuration;
            this._RoleManager = _RoleManager;
            this._authentificationService = _authentificationService;
            this._context = _context;
            this._webHostEnvironment = webHostEnvironment;
        }




        [HttpDelete]
        [Route("deleteEmployer")]
        public async Task DeleteEmployer(string id)
        {
            if (id != null)
            {
                var user = await _usermanager.FindByIdAsync(id);
                if (user != null)
                {
                    BadRequest("user is null");
                }
                var FoundEmployer = await _context.Employer.FirstOrDefaultAsync(x => x.moreInfoId == user.Id);
                _context.Remove(FoundEmployer);
                _context.SaveChanges();
                await _usermanager.DeleteAsync(user);

            }

        }



        [HttpDelete]
        [Route("deleteShopowner")]
        public async Task DeleteShopowner(string id)
        {
            if (id != null)
            {
                var user = await _usermanager.FindByIdAsync(id);
                if (user != null)
                {
                    BadRequest("user is null");
                }
                var FoundEmployer = await _context.Shopowner.FirstOrDefaultAsync(x => x.moreInfoId == user.Id);
                _context.Remove(FoundEmployer);
                _context.SaveChanges();
                await _usermanager.DeleteAsync(user);

            }

        }
        [HttpGet]
        [Route("getbyid/{id}")]
        public async Task<Employee?> GetEmployee([FromRoute] string id)
        {
            var employeeid = await _context.Employee.Where(x => x.EmployeeId == id).Select(x => new Employee()
            {
                EmployeeId = x.EmployeeId,
                NumTel = x.NumTel,
                balance = x.balance,

            }).FirstOrDefaultAsync();

            return employeeid;
        }

        [HttpGet]
        [Route("getall")]
        public async Task<List<Employee>?> GetEmployee()
        {
            var employees = await _context.Employee.Select(x => new Employee()
            {
                EmployeeId = x.EmployeeId,
                NumTel = x.NumTel,
                balance = x.balance,

            }).ToListAsync();

            return employees;
        }

        [HttpGet]
        [Route("employee/current")]
        public ActionResult<string> getloggedInemployeeId()
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            return userId;


        }


        [HttpGet]
        [Route("GetUsers")]
        public async Task<List<Object>> GetUsers(string role)
        {

            var UsersWithRole = await _usermanager.GetUsersInRoleAsync(role);
            List<Object> result = new List<Object>();
            foreach (var user in UsersWithRole)
            {
                var FoundEmployer = new MoreInfoEmployer();
                var FoundShopowner = new ShopOwner();
                if (role == "employer")
                {
                    FoundEmployer = await _context.Employer.AsNoTracking().FirstAsync(x => x.moreInfoId == user.Id);
                    FoundEmployer.employer = user;
                    result.Add(FoundEmployer);
                }
                if (role == "shopowner")
                {
                    FoundShopowner = await _context.Shopowner.AsNoTracking().FirstAsync(x => x.moreInfoId == user.Id);
                    FoundShopowner.employer = user;
                    result.Add(FoundShopowner);
                }

            }

            return result;

        }



        [HttpGet]
        [Route("GetUsersbYid")]
        public async Task<Object> GetUsersById(string id)
        {
            var User = await _usermanager.FindByIdAsync(id);
            var Roles = await _usermanager.GetRolesAsync(User);
            foreach (var role in Roles)
            {
                if (role == "cashier")
                {
                    var Found = await _context.Cassier.AsNoTracking().FirstAsync(x => x.moreInfoId == User.Id);
                    Found.cassier = User;
                    return Found;
                }
                if (role == "employee")
                {
                    var Found = await _context.Employee.AsNoTracking().FirstAsync(x => x.moreInfoId == User.Id);
                    Found.employer = User;
                    return Found;
                }
                if (role == "employer")
                {
                    var Found = await _context.Employer.AsNoTracking().FirstAsync(x => x.moreInfoId == User.Id);
                    Found.employer = User;
                    return Found;
                }
                if (role == "superuser")
                {
                    var Found = User;
                    return Found;
                }
                if (role == "shopowner")
                {
                    var Found = await _context.Shopowner.AsNoTracking().FirstAsync(x => x.moreInfoId == User.Id);
                    Found.employer = User;
                    return Found;
                }
            }
            return "not found";
        }



        [HttpPost]
        [Route("AddTransaction")]
        public async Task<IActionResult> AddTransaction(string? cashierId, string name, double prix)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(name) || prix == 0 || string.IsNullOrWhiteSpace(cashierId))
                {
                    return BadRequest();
                }

                var newTransaction = new Transactions()
                {
                    Cashierid = cashierId,
                    Name = name,
                    prix = prix,
                    datecreation = DateTimeOffset.UtcNow,
                };

                _context.Transactions.Add(newTransaction);
                await _context.SaveChangesAsync();

                return Ok(newTransaction);
            }
            catch (Exception ex)
            {
                // Log the exception or handle it accordingly
                return StatusCode(500, ex.Message);
            }
        }





        [HttpPut]
        [Route("AcceptTransaction")]
        public async Task<IActionResult> AcceptTransaction(string id, string employeeid)
        {
            // retrieve the transaction with the given id from the database
            var transaction = await _context.Transactions.FindAsync(id);

            if (transaction == null)
            {
                // return a not found response if the transaction doesn't exist
                return NotFound();
            }

            // check if isScanned is equal to 0
            if (transaction.isScanned == 0)
            {
                // retrieve the employee with the given employeeid from the database
                var employee = await _context.Employee.FindAsync(employeeid);

                if (employee == null)
                {
                    // return a not found response if the employee doesn't exist
                    return NotFound();
                }

                // get the price of the transaction
                var price = transaction.prix;

                // check if the employee has enough balance to make the transaction
                if (employee.balance == null || employee.balance < price)
                {
                    // return a bad request response if the employee doesn't have enough balance
                    return BadRequest(new { Message = "Employee does not have enough balance", StatusCode = 400 });
                }

                // update the transaction with the new employeeid value
                transaction.Employeeid = employeeid;

                // set isScanned to 1
                transaction.isScanned = 1;

                // deduct the price from the employee's balance
                employee.balance -= price;

                // retrieve the cashier with the given cashierid from the database
                var cashier = await _context.Cassier.FindAsync(transaction.Cashierid);

                if (cashier == null)
                {
                    // return a not found response if the cashier doesn't exist
                    return NotFound();
                }

                // add the price to the cashier's balance
                cashier.balance += price;

                // save the updated transaction, employee, and cashier to the database
                _context.Transactions.Update(transaction);
                _context.Employee.Update(employee);
                _context.Cassier.Update(cashier);
                await _context.SaveChangesAsync();

                // return a success response with the updated transaction
                return Ok(new { Message = "Transaction Successful", StatusCode = 200 });
            }
            else
            {
                // return a bad request response if isScanned is not equal to 0
                return BadRequest(new { Message = "Transaction Already been Made", StatusCode = 400 });
            }
        }





        [HttpGet]
        [Route("getallEmployeetransactions")]
        public async Task<List<Transactions>?> GetAllEmployeeTransactions(string? id)
        {
            // Make sure id is not null before using it to find an employee
            if (id == null)
            {
                return null;
            }

            // Find the employee by id
            var employee = await _context.Employee.FindAsync(id);

            // If employee is null or the id doesn't match, return null
            if (employee == null || employee.EmployeeId != id)
            {
                return null;
            }

            // Get all transactions for the employee with a non-null cashierid
            var transactions = await _context.Transactions
                .Where(x => x.Employeeid == id && x.Cashierid != null)
                .ToListAsync();

            return transactions;
        }



        [HttpGet]
        [Route("getallCashiertransactions")]
        public async Task<List<Transactions>?> GetAllCashierTransactions(string? id)
        {
            // Make sure id is not null before using it to find a cashier
            if (id == null)
            {
                return null;
            }

            // Find the cashier by id
            var cashier = await _context.Cassier.FindAsync(id);

            // If cashier is null or the id doesn't match, return null
            if (cashier == null || cashier.CasierId != id)
            {
                return null;
            }

            // Get all transactions for the cashier with a non-null employeeid
            var transactions = await _context.Transactions
                .Where(x => x.Cashierid == id && x.Employeeid != null)
                .ToListAsync();

            return transactions;
        }



        [HttpGet]
        [Route("searchUsers")]
        public async Task<List<employer3>?> Search(string? username)
        {
            if (string.IsNullOrEmpty(username))
            {
                return null;
            }

            var employees = await _context.Users
                .Where(u => u.UserName.Contains(username))
                .ToListAsync();

            if (employees.Count == 0)
            {
                return null;
            }

            return employees;
        }

        [HttpPost]
        [Route("AddMessage")]
        public async Task<IActionResult> AddMessage(string? employeeId, string? message)
        {
            if (message != null && employeeId != null)
            {
                var new_chat = new Chat()
                {
                    Employeeid = employeeId,
                    Message = message,
                    CreatedAt = DateTime.UtcNow
                };
                _context.Chat.Add(new_chat);
                await _context.SaveChangesAsync();
                return Ok(new_chat);
            }
            else
            {
                return BadRequest();
            }
        }


        [HttpGet]
        [Route("GetMessages")]
        public async Task<IActionResult> GetMessages(string employeeId)
        {
            if (string.IsNullOrEmpty(employeeId))
            {
                return BadRequest();
            }

            var messages = await _context.Chat
                .Where(c => c.Employeeid == employeeId)
                .OrderBy(c => c.CreatedAt)
                .Select(c => c.Message)
                .ToListAsync();

            if (messages == null || messages.Count == 0)
            {
                return NotFound();
            }

            return Ok(messages);
        }

        [HttpGet]
        [Route("GetEmployees")]
        public async Task<IActionResult> GetEmployees()
        {
            try
            {
                var employees = await _context.Employee.AsNoTracking().ToListAsync();
                var employeeUsers = new List<object>();

                foreach (var employee in employees)
                {
                    var user = await _usermanager.FindByIdAsync(employee.moreInfoId);
                    var roles = await _usermanager.GetRolesAsync(user);

                    if (roles.Contains("employee"))
                    {
                        employee.employer = user;
                        employeeUsers.Add(employee);
                    }
                }

                return Ok(employeeUsers);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }



        [HttpGet]
        [Route("GetCashiers")]
        public async Task<IActionResult> GetCashiers()
        {
            try
            {
                var cashiers = await _context.Cassier.AsNoTracking().ToListAsync();
                var cashierUsers = new List<object>();

                foreach (var cashier in cashiers)
                {
                    var user = await _usermanager.FindByIdAsync(cashier.moreInfoId);
                    var roles = await _usermanager.GetRolesAsync(user);

                    if (roles.Contains("cashier"))
                    {
                        cashier.employer = user;
                        cashierUsers.Add(cashier);
                    }
                }

                return Ok(cashierUsers);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }


        [HttpGet]
        [Route("GetTransactions")]
        public async Task<IActionResult> GetTransactions()
        {
            try
            {
                var transactions = await _context.Transactions.AsNoTracking().ToListAsync();
                return Ok(transactions);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }


        [HttpDelete]
        [Route("DeleteEmployee/{employeeId}")]
        public async Task<IActionResult> DeleteEmployee(string employeeId)
        {
            try
            {
                var employee = await _context.Employee.FindAsync(employeeId);

                if (employee == null)
                {
                    return NotFound();
                }

                var userId = employee.moreInfoId; // Get the corresponding user ID
                var user = await _context.Users.FindAsync(userId); // Find the user object

                if (user == null)
                {
                    return NotFound();
                }

                _context.Employee.Remove(employee); // Remove employee
                _context.Users.Remove(user); // Remove user
                await _context.SaveChangesAsync(); // Save changes to the database

                return NoContent();
            }
            catch (Exception ex)
            {
                while (ex.InnerException != null)
                {
                    ex = ex.InnerException;
                }
                return BadRequest(ex.Message);
            }
        }



        [HttpDelete]
        [Route("DeleteCashier/{CasierId}")]
        public async Task<IActionResult> DeleteCashier(string CasierId)
        {
            try
            {
                var cashier = await _context.Cassier.FindAsync(CasierId);

                if (cashier == null)
                {
                    return NotFound();
                }

                var userId = cashier.moreInfoId; // Get the corresponding user ID
                var user = await _context.Users.FindAsync(userId); // Find the user object

                if (user == null)
                {
                    return NotFound();
                }

                _context.Cassier.Remove(cashier); // Remove employee
                _context.Users.Remove(user); // Remove user
                await _context.SaveChangesAsync(); // Save changes to the database

                return NoContent();
            }
            catch (Exception ex)
            {
                while (ex.InnerException != null)
                {
                    ex = ex.InnerException;
                }
                return BadRequest(ex.Message);
            }
        }







        [HttpDelete]
        [Route("Deletetransaction/{transactionid}")]
        public async Task<IActionResult> DeleteTransaction(string transactionid)
        {
            try
            {
                var transaction = await _context.Transactions.FindAsync(transactionid);

                if (transaction == null)
                {
                    return NotFound();
                }

                _context.Transactions.Remove(transaction);
                await _context.SaveChangesAsync();

                return NoContent();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }


        [HttpGet("GetEmployeeById/{id}")]
        public ActionResult<Employee> GetEmployeeById(string id)
        {
            var employee = _context.Employee.Find(id);

            if (employee == null)
            {
                return NotFound();
            }

            return employee;
        }


        [HttpGet("GetCashierById/{id}")]
        public ActionResult<Cassier> GetCashierById(string id)
        {
            var cashier = _context.Cassier.Find(id);

            if (cashier == null)
            {
                return NotFound();
            }

            return cashier;
        }




        [HttpPut("updateemployeeBalance")]
        public async Task<IActionResult> UpdateEmployeeBalance(string? employeeid, double balance, string employerId)
        {
            var employee = await _context.Employee.FindAsync(employeeid);
            if (employee != null)
            {
                employee.balance += balance;

                // Create new instance of Employeebalancehistrique and save to database
                var balanceHistory = new Employeebalancehistrique
                {
                    balancegiven = balance,
                    employeeid = employeeid,
                    datecreation = DateTimeOffset.UtcNow,
                    employerid = employerId
                };

                await _context.Employeebalancehistrique.AddAsync(balanceHistory);

                    await _context.SaveChangesAsync();

            }
            return Ok("balance updated");
        }


        /******************** Get Employee Balance History By Id ***************************************/

        [HttpGet("employeebalancehistory/{employeeid}")]
        public async Task<IActionResult> GetEmployeeBalanceHistory(string? employeeid)
        {
            var balanceHistory = await _context.Employeebalancehistrique
                .Where(e => e.employeeid == employeeid)
                .ToListAsync();

            return Ok(balanceHistory);
        }
        /********************************** End Of Methode *************************************************/



        /******************** Get Employer Balance Added History By Id ***************************************/

        [HttpGet("employerbalanaddedcehistory/{employerid}")]
        public async Task<IActionResult> GetEmployerBalanceAddedHistory(string? employerid)
        {
            var balanceHistory = await _context.Employeebalancehistrique
                .Where(e => e.employerid == employerid)
                .ToListAsync();

            return Ok(balanceHistory);
        }
        /********************************** End Of Methode *************************************************/




        /******************** Get Shopowner Amount Taken History By Id ***************************************/


        [HttpGet("Shopowneramounttakenehistory")]
        public async Task<IActionResult> GetShopownerAmountTakenHistory(string? Shopownerid)
        {
            var balanceHistory = await _context.shopownerHistorique
                .Where(e => e.shopownerid == Shopownerid)
                .ToListAsync();

            return Ok(balanceHistory);
        }


        /************************** End Of Methode ***********************************************************/



        /******************** Get Cashier Balance History By Id ***************************************/


        [HttpGet("Cashierbalancehistory")]
        public async Task<IActionResult> GetCashierBalanceHistory(string? Cashierid)
        {
            var balanceHistory = await _context.shopownerHistorique
                .Where(e => e.cashierid == Cashierid)
                .ToListAsync();

            return Ok(balanceHistory);
        }


        /************************** End Of Methode ***********************************************************/






        [HttpPut("TakeAllCashierBalance")]
        public async Task<IActionResult> UpdateCashierBalance(string id, string shopOwnerId)
        {
            var cashier = await _context.Cassier.FindAsync(id);
            if (cashier != null)
            {
                double cashierBalance = cashier.balance;
                cashier.balance = 0;

                var shopOwner = await _context.Shopowner.FirstOrDefaultAsync(s => s.ShopOwnerIdMoreInfo == shopOwnerId);
                if (shopOwner != null)
                {
                    shopOwner.balance += cashierBalance;

                    // Create a new transaction historic record
                    var historic = new shopownerHistorique
                    {
                        balancetaken = cashierBalance,
                        shopownerid = shopOwnerId,
                        cashierid = id,
                        date = DateTimeOffset.UtcNow,
                    };
                    _context.shopownerHistorique.Add(historic);

                    await _context.SaveChangesAsync();
                }
            }
            return Ok("balance updated");
        }




        [HttpPut("updateCashierBalanceByAmount")]
        public async Task<IActionResult> UpdateCashierBalancebyamount(string id, double amount, string shopOwnerId)
        {
            var cashier = await _context.Cassier.FindAsync(id);
            if (cashier != null)
            {
                if (cashier.balance >= amount)
                {
                    var shopOwner = await _context.Shopowner.FirstOrDefaultAsync(s => s.ShopOwnerIdMoreInfo == shopOwnerId);
                    if (shopOwner != null)
                    {
                        shopOwner.balance += amount;
                        var historique = new shopownerHistorique
                        {
                            balancetaken = amount,
                            shopownerid = shopOwner.ShopOwnerIdMoreInfo,
                            cashierid = cashier.CasierId,
                             date = DateTimeOffset.UtcNow,
                        };
                        _context.shopownerHistorique.Add(historique);
                        cashier.balance -= amount;
                        await _context.SaveChangesAsync();
                        return Ok("balance updated");
                    }
                    else
                    {
                        return BadRequest("Shop owner not found.");
                    }
                }
                else
                {
                    return BadRequest("Cashier balance is not sufficient to complete the transaction.");
                }
            }
            else
            {
                return BadRequest("Cashier not found.");
            }
        }


        /***********************************************       get username of users           ****************************************/ 

        [HttpGet("getEmployeeusername")]
        public async Task<string> getEmployeeusername(string? id)
        {
            var employee = await _context.Employee.FindAsync(id);
            var employerid = employee.moreInfoId;
            var employer = await _context.Employer3.FindAsync(employerid);
            return employer.UserName;

        }


        [HttpGet("getCashierusername")]
        public async Task<string> getCashierusername(string? id)
        {
            var cashier = await _context.Cassier.FindAsync(id);
            var cashierid = cashier.moreInfoId;
            var employer = await _context.Employer3.FindAsync(cashierid);
            return employer.UserName;

        }

        [HttpGet("getEmployerusername")]
        public async Task<string> getEmployerusername(string? id)
        {
            var Employer = await _context.Employer.FindAsync(id);
            var employerid = Employer.moreInfoId;
            var employer = await _context.Employer3.FindAsync(employerid);
            return employer.UserName;

        }

        [HttpGet("getShopownerusername")]
        public async Task<string> getShopownerusername(string? id)
        {
            var shopowner = await _context.Shopowner.FindAsync(id);
            var shopownerid = shopowner.moreInfoId;
            var employer = await _context.Employer3.FindAsync(shopownerid);
            return employer.UserName;

        }


        /************************************************************      End of getting username of users    *****************************************/


    }
}
