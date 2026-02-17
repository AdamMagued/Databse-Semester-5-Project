using System;

namespace WebApplication3
{
    public partial class HRDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        protected void btnAnnualLeave_Click(object sender, EventArgs e)
        {
            Response.Redirect("LeaveApproval.aspx");
        }

        protected void btnUnpaidLeave_Click(object sender, EventArgs e)
        {
            Response.Redirect("UnpaidLeave.aspx");
        }

        protected void btnCompLeave_Click(object sender, EventArgs e)
        {
            Response.Redirect("CompLeaveApproval.aspx");
        }

        protected void btnDeduction_Click(object sender, EventArgs e)
        {
            Response.Redirect("Deduction.aspx");
        }
        protected void btnMonthlyPayroll_Click(object sender, EventArgs e)
        {
            Response.Redirect("Monthly_Payroll.aspx");
        }


    }
}
