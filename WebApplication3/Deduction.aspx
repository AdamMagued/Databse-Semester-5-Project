<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DeductHours.aspx.cs" Inherits="PayrollSystem.DeductHours" %>

<!DOCTYPE html>
<html>
<head>
    <title>Deduction Calculator</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        
        .container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            padding: 40px;
            width: 100%;
            max-width: 500px;
        }
        
        .header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .header h2 {
            color: #333;
            font-size: 28px;
            margin-bottom: 10px;
        }
        
        .header p {
            color: #666;
            font-size: 16px;
        }
        
        .input-group {
            margin-bottom: 25px;
        }
        
        .input-group label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: 600;
            font-size: 16px;
        }
        
        .input-group input {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 16px;
            transition: border-color 0.3s;
        }
        
        .input-group input:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .button-group {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 15px;
            margin-bottom: 25px;
        }
        
        .btn {
            padding: 14px 10px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-align: center;
        }
        
        .btn-hours {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-days {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
        }
        
        .btn-unpaid {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: white;
        }
        
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.2);
        }
        
        .btn:active {
            transform: translateY(0);
        }
        
        .result-box {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            min-height: 60px;
            border-left: 4px solid #667eea;
        }
        
        .result-label {
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
            font-size: 16px;
        }
        
        .result-text {
            color: #666;
            font-size: 16px;
            line-height: 1.5;
        }
        
        .result-success {
            color: #28a745;
        }
        
        .result-error {
            color: #dc3545;
        }
        
        .instructions {
            background: #e3f2fd;
            border-radius: 8px;
            padding: 15px;
            margin-top: 25px;
            font-size: 14px;
            color: #1976d2;
        }
        
        .instructions h4 {
            margin-bottom: 8px;
            color: #0d47a1;
        }
        
        .instructions ul {
            padding-left: 20px;
        }
        
        @media (max-width: 600px) {
            .container {
                padding: 25px;
            }
            
            .button-group {
                grid-template-columns: 1fr;
            }
            
            .header h2 {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div class="container">
        <div class="header">
            <h2>📊 Deduction Calculator</h2>
            <p>Calculate various types of deductions</p>
        </div>
        
        <div class="input-group">
            <label for="txtEmployeeID">👤 Employee ID</label>
            <asp:TextBox ID="txtEmployeeID" runat="server" placeholder="Enter employee ID number"></asp:TextBox>
        </div>
        
        <div class="button-group">
            <asp:Button ID="btnHours" runat="server" Text="🕒 Hours" 
                OnClick="btnHours_Click" CssClass="btn btn-hours" />
                
            <asp:Button ID="btnDays" runat="server" Text="📅 Days" 
                OnClick="btnDays_Click" CssClass="btn btn-days" />
                
            <asp:Button ID="btnUnpaid" runat="server" Text="🌴 Unpaid" 
                OnClick="btnUnpaid_Click" CssClass="btn btn-unpaid" />
        </div>
        
        <div class="result-box">
            <div class="result-label">📋 Result:</div>
            <asp:Label ID="lblResult" runat="server" CssClass="result-text"></asp:Label>
        </div>
        
        <div class="instructions">
            <h4>💡 How to use:</h4>
            <ul>
                <li>Enter Employee ID number</li>
                <li><strong>"Hours"</strong> - Deduct for hours less than 8 per day</li>
                <li><strong>"Days"</strong> - Deduct for absent days</li>
                <li><strong>"Unpaid"</strong> - Deduct for approved unpaid leave this month</li>
                <li>Check deductions table in database for results</li>
            </ul>
        </div>
    </div>
    </form>
</body>
</html>