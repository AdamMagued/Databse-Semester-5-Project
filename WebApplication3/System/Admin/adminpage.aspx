<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="adminpage.aspx.cs" Inherits="WebApplication1.adminpage" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin Dashboard - University HR System</title>
    <style>
        /* Modern Reset and Base Styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 30px;
        }
        
        /* Header Styles */
        .header {
            text-align: center;
            margin-bottom: 40px;
            padding: 20px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .header h1 {
            color: #2c3e50;
            font-size: 2.5em;
            margin-bottom: 10px;
            font-weight: 600;
        }
        
        .header p {
            color: #7f8c8d;
            font-size: 1.1em;
        }
        
        /* Dashboard Grid */
        .dashboard-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 40px;
        }
        
        @media (max-width: 992px) {
            .dashboard-grid {
                grid-template-columns: 1fr;
            }
        }


        /* Alert Message Styles */
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border: 1px solid transparent;
            border-radius: 6px;
            font-weight: 500;
            text-align: center;
            display: block; /* Ensures it takes up space */
        }

        .alert-success {
            color: #155724;
            background-color: #d4edda;
            border-color: #c3e6cb;
        }

        .alert-danger {
            color: #721c24;
            background-color: #f8d7da;
            border-color: #f5c6cb;
        }

        
        /* Card Styles */
        .card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            height: 100%;
        }
        
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }
        
        .card h2 {
            color: #3498db;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #ecf0f1;
            font-size: 1.4em;
            font-weight: 600;
        }
        
        .card h3 {
            color: #2c3e50;
            margin-bottom: 15px;
            font-size: 1.2em;
            font-weight: 500;
        }
        
        /* Form Elements */
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #34495e;
            font-weight: 500;
            font-size: 0.95em;
        }
        
        .input-group {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }
        
        @media (max-width: 768px) {
            .input-group {
                grid-template-columns: 1fr;
            }
        }
        
        .textbox {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e6ed;
            border-radius: 6px;
            font-size: 1em;
            transition: all 0.3s ease;
            background: #f8fafc;
        }
        
        .textbox:focus {
            outline: none;
            border-color: #3498db;
            background: white;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
        }
        
        .btn {
            display: inline-block;
            padding: 12px 24px;
            background: #3498db;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 1em;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-align: center;
            text-decoration: none;
            margin: 5px 0;
            width: 100%;
        }
        
        .btn:hover {
            background: #2980b9;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(52, 152, 219, 0.2);
        }
        
        .btn-secondary {
            background: #2ecc71;
        }
        
        .btn-secondary:hover {
            background: #27ae60;
            box-shadow: 0 4px 8px rgba(46, 204, 113, 0.2);
        }
        
        .btn-danger {
            background: #e74c3c;
        }
        
        .btn-danger:hover {
            background: #c0392b;
            box-shadow: 0 4px 8px rgba(231, 76, 60, 0.2);
        }
        
        .btn-warning {
            background: #f39c12;
        }
        
        .btn-warning:hover {
            background: #d68910;
            box-shadow: 0 4px 8px rgba(243, 156, 18, 0.2);
        }
        
        /* Quick Actions */
        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 15px;
            margin-top: 15px;
        }
        
        /* Results Section */
        .results-section {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
            margin-top: 30px;
        }
        
        .results-section h2 {
            color: #2c3e50;
            margin-bottom: 20px;
            font-size: 1.5em;
            font-weight: 600;
        }
        
        /* GridView Styles */
        .gridview-container {
            overflow-x: auto;
            margin-top: 20px;
            border-radius: 8px;
            border: 1px solid #e0e6ed;
        }
        
        .gridview {
            width: 100%;
            border-collapse: collapse;
        }
        
        .gridview th {
            background: #3498db;
            color: white;
            padding: 12px;
            text-align: left;
            font-weight: 600;
            border: none;
        }
        
        .gridview tr:nth-child(even) {
            background: #f8fafc;
        }
        
        .gridview tr:hover {
            background: #e3f2fd;
        }
        
        .gridview td {
            padding: 12px;
            border-bottom: 1px solid #e0e6ed;
            color: #2c3e50;
        }
        
        /* Icon Styling */
        .icon {
            margin-right: 8px;
            font-size: 1.1em;
        }
        
        /* Footer */
        .footer {
            text-align: center;
            margin-top: 40px;
            padding: 20px;
            color: #7f8c8d;
            font-size: 0.9em;
        }
        
        /* Responsive Adjustments */
        @media (max-width: 480px) {
            .container {
                padding: 15px;
            }
            
            .header h1 {
                font-size: 2em;
            }
            
            .card {
                padding: 20px;
            }
            
            .btn {
                padding: 10px 20px;
            }
        }
    </style>
</head>
<body>
    <!-- ADD THIS FORM TAG -->
    <form id="form1" runat="server">
        <div class="container">
            <div class="header">
                <h1>📊 Admin Dashboard</h1>
                <p>University HR Management System - Administrative Controls</p>
            </div>
            <asp:Label ID="lblMessage" runat="server" Visible="false"></asp:Label>
            <div class="dashboard-grid">
                <!-- Left Column: Employee Management -->
                <div class="card">
                    <h2><span class="icon">👥</span> Employee Management</h2>
                    
                    <div class="quick-actions">
                        <asp:Button ID="btnProfiles" Text="📋 View All Employee Profiles" runat="server" OnClick="btnProfiles_Click" CssClass="btn" />
                        <asp:Button ID="btnDeptCount" Text="🏢 Employee Count By Department" runat="server" OnClick="btnDeptCount_Click" CssClass="btn btn-secondary" />
                        <asp:Button ID="btnRejected" Text="❌ View Rejected Medical Leaves" runat="server" OnClick="btnRejected_Click" CssClass="btn btn-danger" />
                        <asp:Button ID="btnRemoveDeductions" Text="🧹 Remove Resigned Employees Deductions" runat="server" OnClick="btnRemoveDeductions_Click" CssClass="btn btn-warning" />
                    </div>
                    
                    <div class="form-group">
                        <h3>📅 Update Attendance</h3>
                        <div class="input-group">
                            <asp:TextBox ID="txtEmpID_Att" runat="server" Placeholder="Employee ID" CssClass="textbox"></asp:TextBox>
                            <asp:TextBox ID="txtCheckIn" runat="server" Placeholder="Check-in (HH:mm)" CssClass="textbox"></asp:TextBox>
                            <asp:TextBox ID="txtCheckOut" runat="server" Placeholder="Check-out (HH:mm)" CssClass="textbox"></asp:TextBox>
                        </div>
                        <asp:Button ID="btnUpdateAttendance" Text="🔄 Update Employee Attendance" runat="server" OnClick="btnUpdateAttendance_Click" CssClass="btn" />
                    </div>
                </div>
                
                <!-- Right Column: System Operations -->
                <div class="card">
                    <h2><span class="icon">⚙</span> System Operations</h2>
                    
                    <div class="form-group">
                        <h3>🎉 Add New Holiday</h3>
                        <div class="input-group">
                            <asp:TextBox ID="txtHolidayName" runat="server" Placeholder="Holiday Name" CssClass="textbox"></asp:TextBox>
                            <asp:TextBox ID="txtFromDate" runat="server" Placeholder="From Date (YYYY-MM-DD)" CssClass="textbox"></asp:TextBox>
                            <asp:TextBox ID="txtToDate" runat="server" Placeholder="To Date (YYYY-MM-DD)" CssClass="textbox"></asp:TextBox>
                        </div>
                        <asp:Button ID="btnAddHoliday" Text="➕ Add Holiday" runat="server" OnClick="btnAddHoliday_Click" CssClass="btn btn-secondary" />
                    </div>
                    
                    <div class="form-group">
                        <h3>⏰ Attendance Operations</h3>
                        <asp:Button ID="btnInitiateAttendance" Text="🚀 Initiate Attendance for All Employees" runat="server" OnClick="btnInitiateAttendance_Click" CssClass="btn" />
                    </div>
                </div>
            </div>
            
            <!-- Results Display Section -->
            <div class="results-section">
                <h2><span class="icon">📊</span> Results</h2>
                <div class="gridview-container">
                    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="True" CssClass="gridview"></asp:GridView>
                </div>
            </div>
            
            <div class="footer">
                <p>© 2025 University HR Management System | Admin Dashboard v1.0</p>
            </div>
        </div>
    <!-- CLOSE THE FORM TAG -->
    </form>
</body>
</html>