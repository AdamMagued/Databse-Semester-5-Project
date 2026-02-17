<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HR_Dashboard.aspx.cs" Inherits="WebApplication3.HRDashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>HR Dashboard</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
        }

        .dashboard-container {
            width: 700px;
            margin: 50px auto;
            background-color: #ffffff;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0px 4px 20px rgba(0,0,0,0.3);
            text-align: center;
        }

        h2 {
            color: #007BFF;
            margin-bottom: 40px;
        }

        .dashboard-button {
            width: 100%;
            max-width: 400px;
            padding: 20px;
            margin: 15px auto;
            font-size: 18px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            background-color: #007BFF;
            color: white;
            transition: 0.3s;
        }

        .dashboard-button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="dashboard-container">
            <h2>HR Dashboard</h2>

            <asp:Button ID="btnAnnualLeave" runat="server" Text="Approve/Reject Annual/Accidental Leaves" CssClass="dashboard-button" OnClick="btnAnnualLeave_Click" /><br />
            <asp:Button ID="btnUnpaidLeave" runat="server" Text="Approve/Reject Unpaid Leaves" CssClass="dashboard-button" OnClick="btnUnpaidLeave_Click" /><br />
            <asp:Button ID="btnCompLeave" runat="server" Text="Approve/Reject Compensation Leaves" CssClass="dashboard-button" OnClick="btnCompLeave_Click" /><br />
            <asp:Button ID="btnDeduction" runat="server" Text="Add Deduction for Missing Hours" CssClass="dashboard-button" OnClick="btnDeduction_Click" /><br />
            <asp:Button ID="btnMonthlyPayroll" runat="server" Text="Generate Monthly Payroll" CssClass="dashboard-button" OnClick="btnMonthlyPayroll_Click" /><br />
        </div>
    </form>
</body>
</html>