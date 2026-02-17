using System;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication4.Admin
{
    public partial class WinterPerformance : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadFilters();
                LoadWinterPerformance();
            }
        }

        private void LoadFilters()
        {
            try
            {
                string connectionString = WebConfigurationManager.ConnectionStrings["MyDatabaseConnection"].ToString();

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Load semesters
                    string semesterQuery = "SELECT DISTINCT semester FROM Performance WHERE semester LIKE 'W%' ORDER BY semester DESC";
                    using (SqlCommand cmd = new SqlCommand(semesterQuery, conn))
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            ddlSemester.Items.Add(new ListItem(reader["semester"].ToString(), reader["semester"].ToString()));
                        }
                    }

                    // Load departments
                    string deptQuery = @"SELECT DISTINCT e.dept_name 
                                       FROM Performance p
                                       INNER JOIN Employee e ON p.emp_ID = e.employee_id
                                       WHERE p.semester LIKE 'W%' AND e.dept_name IS NOT NULL
                                       ORDER BY e.dept_name";
                    using (SqlCommand cmd = new SqlCommand(deptQuery, conn))
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            ddlDepartment.Items.Add(new ListItem(reader["dept_name"].ToString(), reader["dept_name"].ToString()));
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = $"Error loading filters: {ex.Message}";
                lblMessage.CssClass = "message error";
                lblMessage.Visible = true;
            }
        }

        private void LoadWinterPerformance()
        {
            try
            {
                string connectionString = WebConfigurationManager.ConnectionStrings["MyDatabaseConnection"].ToString();

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Build query with filters
                    StringBuilder query = new StringBuilder();
                    query.Append(@"SELECT 
                                p.performance_ID,
                                p.emp_ID,
                                p.rating,
                                p.comments,
                                p.semester,
                                e.first_name + ' ' + e.last_name as employee_name,
                                e.dept_name as department
                                FROM allPerformance p
                                INNER JOIN Employee e ON p.emp_ID = e.employee_id
                                WHERE 1=1");

                    // Apply filters
                    if (!string.IsNullOrEmpty(ddlSemester.SelectedValue))
                    {
                        query.Append($" AND p.semester = '{ddlSemester.SelectedValue}'");
                    }

                    if (!string.IsNullOrEmpty(ddlDepartment.SelectedValue))
                    {
                        query.Append($" AND e.dept_name = '{ddlDepartment.SelectedValue}'");
                    }

                    if (!string.IsNullOrEmpty(ddlMinRating.SelectedValue) && ddlMinRating.SelectedValue != "0")
                    {
                        int minRating = int.Parse(ddlMinRating.SelectedValue);
                        query.Append($" AND p.rating >= {minRating}");
                    }

                    query.Append(" ORDER BY p.semester DESC, p.rating DESC, e.last_name");

                    using (SqlCommand cmd = new SqlCommand(query.ToString(), conn))
                    using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        adapter.Fill(dt);

                        // Bind to GridView
                        gvPerformance.DataSource = dt;
                        gvPerformance.DataBind();

                        // Update statistics
                        UpdateStatistics(dt);

                        // Update rating distribution
                        UpdateRatingDistribution(dt);

                        // Show message
                        if (dt.Rows.Count > 0)
                        {
                            lblMessage.Text = $"✅ Found {dt.Rows.Count} performance records for Winter semesters";
                            lblMessage.CssClass = "message success";
                            lblMessage.Visible = true;
                        }
                        else
                        {
                            lblMessage.Text = "ℹ️ No performance records found for Winter semesters";
                            lblMessage.CssClass = "message warning";
                            lblMessage.Visible = true;
                        }
                    }
                }
            }
            catch (SqlException ex)
            {
                lblMessage.Text = $"❌ Database error: {ex.Message}";
                lblMessage.CssClass = "message error";
                lblMessage.Visible = true;
            }
            catch (Exception ex)
            {
                lblMessage.Text = $"❌ Error: {ex.Message}";
                lblMessage.CssClass = "message error";
                lblMessage.Visible = true;
            }
        }

        private void UpdateStatistics(DataTable dt)
        {
            int total = dt.Rows.Count;
            double totalRating = 0;
            int lowestRating = 5;
            int uniqueEmployees = 0;

            if (total > 0)
            {
                // Track unique employees
                System.Collections.Generic.HashSet<int> employeeSet = new System.Collections.Generic.HashSet<int>();

                foreach (DataRow row in dt.Rows)
                {
                    int rating = Convert.ToInt32(row["rating"]);
                    int empId = Convert.ToInt32(row["emp_ID"]);

                    totalRating += rating;

                    if (rating < lowestRating)
                        lowestRating = rating;

                    employeeSet.Add(empId);
                }

                uniqueEmployees = employeeSet.Count;
                double avgRating = totalRating / total;

                lblTotalRecords.Text = total.ToString();
                lblAvgRating.Text = avgRating.ToString("0.0");
                lblUniqueEmployees.Text = uniqueEmployees.ToString();
                lblLowestRating.Text = lowestRating.ToString();
            }
            else
            {
                lblTotalRecords.Text = "0";
                lblAvgRating.Text = "0.0";
                lblUniqueEmployees.Text = "0";
                lblLowestRating.Text = "0";
            }
        }

        private void UpdateRatingDistribution(DataTable dt)
        {
            int rating1 = 0, rating2 = 0, rating3 = 0, rating4 = 0, rating5 = 0;

            foreach (DataRow row in dt.Rows)
            {
                int rating = Convert.ToInt32(row["rating"]);
                switch (rating)
                {
                    case 1: rating1++; break;
                    case 2: rating2++; break;
                    case 3: rating3++; break;
                    case 4: rating4++; break;
                    case 5: rating5++; break;
                }
            }

            lblRating1.Text = rating1.ToString();
            lblRating2.Text = rating2.ToString();
            lblRating3.Text = rating3.ToString();
            lblRating4.Text = rating4.ToString();
            lblRating5.Text = rating5.ToString();

            // Scale bars for visualization (max height 120px)
            int maxCount = Math.Max(rating5, Math.Max(rating4, Math.Max(rating3, Math.Max(rating2, rating1))));
            if (maxCount > 0)
            {
                bar1.Style["height"] = (rating1 * 120 / maxCount) + "px";
                bar2.Style["height"] = (rating2 * 120 / maxCount) + "px";
                bar3.Style["height"] = (rating3 * 120 / maxCount) + "px";
                bar4.Style["height"] = (rating4 * 120 / maxCount) + "px";
                bar5.Style["height"] = (rating5 * 120 / maxCount) + "px";
            }
        }

        // Helper method for star display
        public string GetStarRating(object ratingObj)
        {
            if (ratingObj == null) return "★";
            int rating = Convert.ToInt32(ratingObj);
            return new string('★', rating) + new string('☆', 5 - rating);
        }

        // Helper method for rating CSS class
        public string GetRatingClass(object ratingObj)
        {
            if (ratingObj == null) return "rating-3";
            int rating = Convert.ToInt32(ratingObj);
            return $"rating-{rating}";
        }

        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            LoadWinterPerformance();
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("AdminDashboard.aspx");
        }

        protected void ddlSemester_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadWinterPerformance();
        }

        protected void ddlDepartment_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadWinterPerformance();
        }

        protected void ddlMinRating_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadWinterPerformance();
        }

        protected void btnClearFilters_Click(object sender, EventArgs e)
        {
            ddlSemester.SelectedIndex = 0;
            ddlDepartment.SelectedIndex = 0;
            ddlMinRating.SelectedIndex = 0;
            LoadWinterPerformance();
        }

        protected void btnViewDetails_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            string performanceId = btn.CommandArgument;

            // Show performance details (could be a modal or separate page)
            lblMessage.Text = $"ℹ️ Viewing details for Performance ID: {performanceId}";
            lblMessage.CssClass = "message warning";
            lblMessage.Visible = true;

            // You could implement a modal popup here
            // ScriptManager.RegisterStartupScript(this, GetType(), "showModal", 
            //     $"showPerformanceDetails({performanceId});", true);
        }

        protected void btnViewEmployee_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            string employeeId = btn.CommandArgument;

            // Redirect to employee profile or show in modal
            lblMessage.Text = $"ℹ️ Viewing profile for Employee ID: {employeeId}";
            lblMessage.CssClass = "message warning";
            lblMessage.Visible = true;
        }

        protected void btnExportExcel_Click(object sender, EventArgs e)
        {
            try
            {
                string connectionString =  WebConfigurationManager.ConnectionStrings["MyDatabaseConnection"].ToString();

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    string query = @"SELECT 
                                    p.performance_ID as 'ID',
                                    p.emp_ID as 'Employee ID',
                                    e.first_name + ' ' + e.last_name as 'Employee Name',
                                    e.dept_name as 'Department',
                                    p.rating as 'Rating',
                                    p.comments as 'Comments',
                                    p.semester as 'Semester'
                                    FROM allPerformance p
                                    INNER JOIN Employee e ON p.emp_ID = e.employee_id
                                    ORDER BY p.semester DESC, p.rating DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        adapter.Fill(dt);

                        // Export to Excel
                        ExportToExcel(dt, $"Winter_Performance_{DateTime.Now:yyyyMMdd}.xls");
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = $"❌ Export error: {ex.Message}";
                lblMessage.CssClass = "message error";
                lblMessage.Visible = true;
            }
        }

        private void ExportToExcel(DataTable dt, string filename)
        {
            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", $"attachment;filename={filename}");
            Response.Charset = "";
            Response.ContentType = "application/vnd.ms-excel";

            using (System.IO.StringWriter sw = new System.IO.StringWriter())
            {
                System.Web.UI.HtmlTextWriter hw = new System.Web.UI.HtmlTextWriter(sw);

                // Add title
                hw.WriteLine("<h2>Winter Semester Performance Report</h2>");
                hw.WriteLine($"<h3>Generated: {DateTime.Now:dddd, MMMM dd, yyyy}</h3>");
                hw.WriteLine("<br/>");

                // Add statistics
                hw.WriteLine($"<p><strong>Total Records:</strong> {dt.Rows.Count}</p>");

                // Create table
                hw.Write("<table border='1' cellpadding='5' cellspacing='0'>");

                // Add header
                hw.Write("<tr>");
                foreach (DataColumn column in dt.Columns)
                {
                    hw.Write($"<th bgcolor='#007bff' style='color:white;'>{column.ColumnName}</th>");
                }
                hw.Write("</tr>");

                // Add rows
                foreach (DataRow row in dt.Rows)
                {
                    hw.Write("<tr>");
                    foreach (DataColumn column in dt.Columns)
                    {
                        string value = row[column].ToString();
                        if (column.ColumnName == "Rating")
                        {
                            // Add stars for rating
                            int rating = int.Parse(value);
                            value = $"{new string('★', rating)} ({rating})";
                        }
                        hw.Write($"<td>{value}</td>");
                    }
                    hw.Write("</tr>");
                }

                hw.Write("</table>");

                Response.Output.Write(sw.ToString());
                Response.Flush();
                Response.End();
            }
        }

        protected void btnExportPDF_Click(object sender, EventArgs e)
        {
            lblMessage.Text = "ℹ️ PDF export feature requires additional setup";
            lblMessage.CssClass = "message warning";
            lblMessage.Visible = true;
        }

        protected void btnPrint_Click(object sender, EventArgs e)
        {
            // Printing is handled by JavaScript in the OnClientClick event
        }

        protected void gvPerformance_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvPerformance.PageIndex = e.NewPageIndex;
            LoadWinterPerformance();
        }
    }
}