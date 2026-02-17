<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Monthly_Payroll.aspx.cs" Inherits="WebApplication3.Monthly_Payroll" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Generate Monthly Payroll</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f9;
            margin: 0;
            padding: 20px;
        }
        
        .container {
            max-width: 600px;
            margin: 0 auto;
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }
        
        h2 {
            color: #2c3e50;
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 10px;
            border-bottom: 2px solid #3498db;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        label {
            display: block;
            margin-bottom: 5px;
            color: #34495e;
            font-weight: bold;
        }
        
        input[type="text"], input[type="date"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #bdc3c7;
            border-radius: 5px;
            font-size: 16px;
            box-sizing: border-box;
        }
        
        input[type="text"]:focus, input[type="date"]:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 5px rgba(52, 152, 219, 0.3);
        }
        
        .btn-generate {
            background-color: #27ae60;
            color: white;
            border: none;
            padding: 12px 24px;
            font-size: 16px;
            border-radius: 5px;
            cursor: pointer;
            width: 100%;
            margin-top: 10px;
            transition: background-color 0.3s;
        }
        
        .btn-generate:hover {
            background-color: #219653;
        }
        
        .message {
            margin-top: 20px;
            padding: 15px;
            border-radius: 5px;
            text-align: center;
            display: none;
        }
        
        .message.success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
            display: block;
        }
        
        .message.error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
            display: block;
        }
        
        .message.info {
            background-color: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
            display: block;
        }
        
        .payroll-details {
            margin-top: 30px;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 5px;
            border-left: 4px solid #3498db;
        }
        
        .detail-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            padding-bottom: 10px;
            border-bottom: 1px solid #e9ecef;
        }
        
        .detail-label {
            font-weight: bold;
            color: #495057;
        }
        
        .detail-value {
            color: #212529;
        }
        
        .final-salary {
            font-size: 20px;
            font-weight: bold;
            color: #27ae60;
            margin-top: 10px;
            padding-top: 10px;
            border-top: 2px solid #27ae60;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <h2>Generate Monthly Payroll</h2>
            
            <div class="form-group">
                <label for="txtEmployeeID">Employee ID</label>
                <asp:TextBox ID="txtEmployeeID" runat="server" placeholder="Enter employee ID"></asp:TextBox>
            </div>
            
            <div class="form-group">
                <label for="txtFromDate">From Date</label>
                <asp:TextBox ID="txtFromDate" runat="server" TextMode="Date"></asp:TextBox>
            </div>
            
            <div class="form-group">
                <label for="txtToDate">To Date</label>
                <asp:TextBox ID="txtToDate" runat="server" TextMode="Date"></asp:TextBox>
            </div>
            
            <asp:Button ID="btnGenerate" runat="server" Text="Generate Payroll" 
                CssClass="btn-generate" OnClick="btnGenerate_Click" />
            
            <asp:Label ID="lblResult" runat="server" CssClass="message" Visible="false"></asp:Label>
            
            <div id="payrollDetails" runat="server" class="payroll-details" visible="false">
                <h3>Payroll Details</h3>
                <div class="detail-row">
                    <span class="detail-label">Employee Name:</span>
                    <span class="detail-value" id="empName" runat="server"></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Pay Period:</span>
                    <span class="detail-value" id="payPeriod" runat="server"></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Base Salary:</span>
                    <span class="detail-value" id="baseSalary" runat="server"></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Bonus Amount:</span>
                    <span class="detail-value" id="bonusAmount" runat="server"></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Deductions:</span>
                    <span class="detail-value" id="deductions" runat="server"></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Comments:</span>
                    <span class="detail-value" id="comments" runat="server"></span>
                </div>
                <div class="detail-row final-salary">
                    <span class="detail-label">Final Salary:</span>
                    <span class="detail-value" id="finalSalary" runat="server"></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Generated On:</span>
                    <span class="detail-value" id="generatedDate" runat="server"></span>
                </div>
            </div>
        </div>
    </form>
</body>
</html>