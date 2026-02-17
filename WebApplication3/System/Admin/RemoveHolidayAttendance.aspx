<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RemoveHolidayAttendance.aspx.cs" Inherits="WebApplication4.Admin.RemoveHolidayAttendance" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Remove Holiday Attendance</title>
    <style>
        body { font-family: Arial; padding: 20px; background: #f5f5f5; }
        .header { background: #007bff; color: white; padding: 15px; border-radius: 5px; margin-bottom: 20px; }
        .container { background: white; padding: 20px; border-radius: 5px; border: 1px solid #ddd; }
        .button { padding: 10px 20px; background: #007bff; color: white; border: none; border-radius: 5px; cursor: pointer; margin-right: 10px; }
        .button:hover { background: #0056b3; }
        .button-danger { background: #dc3545; }
        .button-danger:hover { background: #c82333; }
        .button-secondary { background: #6c757d; }
        .button-secondary:hover { background: #545b62; }
        .button-success { background: #28a745; }
        .button-success:hover { background: #218838; }
        .message { padding: 15px; margin: 15px 0; border-radius: 5px; }
        .success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .warning { background: #fff3cd; color: #856404; border: 1px solid #ffeaa7; }
        .error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .info { background: #d1ecf1; color: #0c5460; border: 1px solid #bee5eb; }
        .section { margin-bottom: 30px; padding: 20px; background: #f8f9fa; border-radius: 5px; }
        .section-title { color: #007bff; margin-top: 0; border-bottom: 2px solid #007bff; padding-bottom: 10px; }
        .stats-container { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; margin-bottom: 20px; }
        .stat-box { padding: 15px; border-radius: 5px; text-align: center; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th { background: #007bff; color: white; padding: 12px; text-align: left; }
        td { padding: 10px; border-bottom: 1px solid #ddd; }
        tr:hover { background: #f5f5f5; }
        .no-data { text-align: center; padding: 30px; color: #6c757d; font-style: italic; }
        .confirmation-box { background: #fff3cd; padding: 20px; border-radius: 5px; margin: 20px 0; border: 2px solid #ffc107; }
        .holiday-item { padding: 10px; margin: 5px 0; background: white; border-radius: 3px; border-left: 4px solid #007bff; }
        .danger-zone { background: #f8d7da; padding: 20px; border-radius: 5px; margin: 20px 0; border: 2px solid #dc3545; }
        .status-attended { color: #28a745; font-weight: bold; }
        .status-absent { color: #dc3545; font-weight: bold; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">
            <h1>🗑️ Remove Holiday Attendance Records</h1>
            <p>Delete attendance records for all employees during official holidays</p>
        </div>
        
        <div class="container">
            <!-- Navigation Buttons -->
            <div style="margin-bottom: 20px;">
                <asp:Button ID="btnBack" runat="server" Text="← Back to Dashboard" OnClick="btnBack_Click" CssClass="button button-secondary" />
                <asp:Button ID="btnRefresh" runat="server" Text="🔄 Refresh Data" OnClick="btnRefresh_Click" CssClass="button" />
            </div>
            
            <!-- Message Display -->
            <asp:Label ID="lblMessage" runat="server" CssClass="message" Visible="false"></asp:Label>
            
            <!-- Section 1: Current Holidays -->
            <div class="section">
                <h2 class="section-title">📅 Current Holidays in System</h2>
                <asp:GridView ID="gvHolidays" runat="server" AutoGenerateColumns="false" 
                    CssClass="holidays-table" GridLines="None" ShowHeaderWhenEmpty="true"
                    EmptyDataText="No holidays found in the system">
                    <Columns>
                        <asp:BoundField DataField="holiday_name" HeaderText="Holiday Name" ItemStyle-Width="150px" />
                        <asp:BoundField DataField="from_date" HeaderText="From Date" DataFormatString="{0:yyyy-MM-dd}" ItemStyle-Width="120px" />
                        <asp:BoundField DataField="to_date" HeaderText="To Date" DataFormatString="{0:yyyy-MM-dd}" ItemStyle-Width="120px" />
                        <asp:TemplateField HeaderText="Duration" ItemStyle-Width="100px">
                            <ItemTemplate>
                                <%# FormatHolidayDuration(Eval("from_date"), Eval("to_date")) %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="attendance_count" HeaderText="Affected Records" ItemStyle-Width="120px" 
                            ItemStyle-Font-Bold="true" ItemStyle-ForeColor="#dc3545" />
                    </Columns>
                    <HeaderStyle BackColor="#007bff" ForeColor="White" Font-Bold="true" />
                    <RowStyle CssClass="table-row" />
                    <AlternatingRowStyle BackColor="#f9f9f9" />
                    <EmptyDataRowStyle CssClass="no-data" />
                </asp:GridView>
                
                
            </div>
            
            <!-- Section 2: Affected Attendance Preview -->
            <div class="section">
                <h2 class="section-title">👀 Affected Attendance Records Preview</h2>
                <p>These attendance records will be deleted (first 50 shown):</p>
                
                <asp:GridView ID="gvAffectedAttendance" runat="server" AutoGenerateColumns="false" 
                    CssClass="attendance-table" GridLines="None" ShowHeaderWhenEmpty="true"
                    EmptyDataText="No attendance records found during holidays">
                    <Columns>
                        <asp:BoundField DataField="attendance_ID" HeaderText="ID" ItemStyle-Width="50px" />
                        <asp:BoundField DataField="emp_ID" HeaderText="Employee ID" ItemStyle-Width="100px" />
                        <asp:BoundField DataField="employee_name" HeaderText="Employee Name" ItemStyle-Width="150px" />
                        <asp:BoundField DataField="date" HeaderText="Date" DataFormatString="{0:yyyy-MM-dd}" ItemStyle-Width="100px" />
                        <asp:BoundField DataField="check_in_time" HeaderText="Check In" DataFormatString="{0:hh\:mm\:ss}" ItemStyle-Width="80px" />
                        <asp:BoundField DataField="check_out_time" HeaderText="Check Out" DataFormatString="{0:hh\:mm\:ss}" ItemStyle-Width="80px" />
                        <asp:TemplateField HeaderText="Status" ItemStyle-Width="80px">
                            <ItemTemplate>
                                <span class='<%# Eval("status").ToString().ToLower() == "attended" ? "status-attended" : "status-absent" %>'>
                                    <%# Eval("status") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="holiday_name" HeaderText="Holiday" ItemStyle-Width="120px" />
                    </Columns>
                    <HeaderStyle BackColor="#007bff" ForeColor="White" Font-Bold="true" />
                    <RowStyle CssClass="table-row" />
                    <AlternatingRowStyle BackColor="#f9f9f9" />
                    <EmptyDataRowStyle CssClass="no-data" />
                </asp:GridView>
                
                <!-- Statistics -->
                <div class="stats-container" style="margin-top: 20px;">
                    <div class="stat-box" style="background: #e7f3ff;">
                        <h3 style="margin: 0; color: #007bff;">Total to Delete</h3>
                        <asp:Label ID="lblTotalToDelete" runat="server" Text="0" Style="font-size: 24px; font-weight: bold;"></asp:Label>
                    </div>
                    <div class="stat-box" style="background: #d4edda;">
                        <h3 style="margin: 0; color: #28a745;">Attended Records</h3>
                        <asp:Label ID="lblAttendedCount" runat="server" Text="0" Style="font-size: 24px; font-weight: bold;"></asp:Label>
                    </div>
                    <div class="stat-box" style="background: #f8d7da;">
                        <h3 style="margin: 0; color: #dc3545;">Absent Records</h3>
                        <asp:Label ID="lblAbsentCount" runat="server" Text="0" Style="font-size: 24px; font-weight: bold;"></asp:Label>
                    </div>
                    <div class="stat-box" style="background: #fff3cd;">
                        <h3 style="margin: 0; color: #ffc107;">Affected Employees</h3>
                        <asp:Label ID="lblAffectedEmployees" runat="server" Text="0" Style="font-size: 24px; font-weight: bold;"></asp:Label>
                    </div>
                </div>
            </div>
            
            <!-- Section 3: Confirmation and Action -->
            <div class="danger-zone">
                <h2 style="color: #dc3545; margin-top: 0;">⚠️ DANGER ZONE - IRREVERSIBLE ACTION</h2>
                <p><strong>Warning:</strong> This action will permanently delete attendance records that fall on official holidays.</p>
                <p>Once deleted, these records cannot be recovered.</p>
                
                <div class="confirmation-box">
                    <h3>🔒 Confirmation Required</h3>
                    <p>Please confirm you want to proceed:</p>
                    
                    <div style="margin: 15px 0;">
                        <asp:CheckBox ID="chkConfirmDelete" runat="server" Text="I understand this action is irreversible" AutoPostBack="true" OnCheckedChanged="chkConfirmDelete_CheckedChanged" />
                    </div>
                    
                    <div style="margin: 15px 0;">
                        <asp:CheckBox ID="chkBackupData" runat="server" Text="Create backup before deletion (recommended)" Checked="true" />
                    </div>
                    
                    <div style="margin-top: 20px;">
                        <asp:Button ID="btnPreviewOnly" runat="server" Text="👁️ Preview Only (Safe)" OnClick="btnPreviewOnly_Click" 
                            CssClass="button button-secondary" />
                        <asp:Button ID="btnExecuteDelete" runat="server" Text="🗑️ EXECUTE DELETE" OnClick="btnExecuteDelete_Click" 
                            CssClass="button button-danger" Enabled="false" />
                    </div>
                </div>
            </div>
            
            <!-- Section 4: Backup and Logs -->
            <div class="section">
                <h2 class="section-title">📋 Operation Logs</h2>
                <p>Last operations performed:</p>
                
                <asp:GridView ID="gvOperationLogs" runat="server" AutoGenerateColumns="false" 
                    CssClass="logs-table" GridLines="None" ShowHeaderWhenEmpty="true"
                    EmptyDataText="No operation logs available">
                    <Columns>
                        <asp:BoundField DataField="timestamp" HeaderText="Time" DataFormatString="{0:yyyy-MM-dd HH:mm}" ItemStyle-Width="120px" />
                        <asp:BoundField DataField="operation_type" HeaderText="Operation" ItemStyle-Width="150px" />
                        <asp:BoundField DataField="records_affected" HeaderText="Records Affected" ItemStyle-Width="100px" />
                        <asp:BoundField DataField="performed_by" HeaderText="Performed By" ItemStyle-Width="120px" />
                        <asp:BoundField DataField="status" HeaderText="Status" ItemStyle-Width="80px" />
                        <asp:BoundField DataField="notes" HeaderText="Notes" ItemStyle-Width="200px" />
                    </Columns>
                    <HeaderStyle BackColor="#007bff" ForeColor="White" Font-Bold="true" />
                    <RowStyle CssClass="table-row" />
                    <AlternatingRowStyle BackColor="#f9f9f9" />
                    <EmptyDataRowStyle CssClass="no-data" />
                </asp:GridView>
            </div>
            
            <!-- Export Options -->
            <div style="margin-top: 20px; border-top: 1px solid #ddd; padding-top: 20px;">
                <h3>Export Options</h3>
                <asp:Button ID="btnExportHolidays" runat="server" Text="📅 Export Holidays List" OnClick="btnExportHolidays_Click" CssClass="button" />
                <asp:Button ID="btnExportAffected" runat="server" Text="📊 Export Affected Records" OnClick="btnExportAffected_Click" CssClass="button" />
                <asp:Button ID="btnPrintReport" runat="server" Text="🖨️ Print Report" OnClick="btnPrintReport_Click" CssClass="button" 
                    OnClientClick="window.print(); return false;" />
            </div>
        </div>
        
        <!-- Hidden Fields -->
        <asp:HiddenField ID="hdnAffectedCount" runat="server" Value="0" />
        <asp:HiddenField ID="hdnHolidayCount" runat="server" Value="0" />
    </form>
    
    <script type="text/javascript">
        function confirmDelete() {
            var confirmDelete = confirm('⚠️ WARNING: This will permanently delete attendance records during holidays.\n\nThis action cannot be undone!\n\nAre you absolutely sure?');
            if (confirmDelete) {
                // Show additional confirmation
                var doubleConfirm = confirm('FINAL CONFIRMATION:\n\nYou are about to delete attendance records.\n\nClick OK to proceed or Cancel to abort.');
                return doubleConfirm;
            }
            return false;
        }

        function updateDeleteButton() {
            var checkbox = document.getElementById('<%= chkConfirmDelete.ClientID %>');
            var deleteButton = document.getElementById('<%= btnExecuteDelete.ClientID %>');
            if (checkbox && deleteButton) {
                deleteButton.disabled = !checkbox.checked;
            }
        }

        // Initialize on page load
        window.onload = function () {
            updateDeleteButton();
        };
    </script>
</body>
</html>
