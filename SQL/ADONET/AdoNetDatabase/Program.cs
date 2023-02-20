using Microsoft.Extensions.Configuration;
using System.Data.SqlClient;

internal class Program
{
    private static string _connectionString = string.Empty;
    private static void Main(string[] args)
    {
        var configuration = new ConfigurationBuilder()
            .SetBasePath(Directory.GetCurrentDirectory())
            .AddJsonFile($"appsettings.json");
         
        var config = configuration.Build();
        _connectionString = config.GetConnectionString("Db1");

        Select();
        Insert();
        Console.ReadKey();
    }

    private static void Select()
    {
        try
        {
            using (var con = new SqlConnection(_connectionString))
            {
                con.Open();
                SqlCommand cmd = new("select * from lager.Kategorie order by Kategorie_ID", con);
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    Console.WriteLine($"{dr["Kategorie_ID"]}, {dr["Kategorie"]}");
                }
            }
        }
        catch(Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
    }

    private static void Insert()
    {
        try
        {
            Console.WriteLine("Bitte neue Kategorie eingeben?");
            string kategorie = Console.ReadLine();

            using (var con = new SqlConnection(_connectionString))
            {
                con.Open();
                SqlCommand cmd = new($"insert into lager.Kategorie (Kategorie) values ('{kategorie}')", con);
                int affectedRows = cmd.ExecuteNonQuery();
                if (affectedRows > 0)
                    Console.WriteLine("Datensatz wurde eingefügt");
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
    }
}