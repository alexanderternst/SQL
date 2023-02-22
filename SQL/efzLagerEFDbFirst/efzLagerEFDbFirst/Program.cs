using efzLagerEFDbFirst.Models;
using Microsoft.EntityFrameworkCore;

internal class Program
{
    private static void Main(string[] args)
    {
        // NuGet Packages:
        // Microsoft.EntityFrameworkCore.SqlServer
        // Microsoft.EntityFrameworkCore.Tools
        /////////////////////////////////////
        // Package Manager Console:
        // Scaffold-DbContext "Server=ALEXANDERPC;Database=efzLager;Trusted_Connection=True;" Microsoft.EntityFrameworkCore.SqlServer -OutputDir Models -Context efzLagerContext
        Insert();
        Select();
        Console.ReadKey();
    }

    private static void Select()
    {
        var contextOptions = new DbContextOptionsBuilder<efzLagerContext>()
            .UseSqlServer(@"Server=ALEXANDERPC;Database=efzLager;Trusted_Connection=True;")
            .Options;

        using (var context = new efzLagerContext(contextOptions))
        {
            foreach (var k in context.Kategories)
            {
                Console.WriteLine($"{k.KategorieId}, {k.Kategorie1}");
            }

            var q = context.Kategories.Where(e => e.Kategorie1 == "Bikes").FirstOrDefault();
            if (q != null)
            {
                Console.WriteLine($"\n{q.KategorieId}, {q.Kategorie1}\n");

                foreach (var u in q.Unterkategories)
                {
                    Console.WriteLine($"{u.Unterkategorie1}");
                }
            }
        }
    }
    private static void Insert()
    {
        var contextOptions = new DbContextOptionsBuilder<efzLagerContext>()
            .UseSqlServer(@"Server=ALEXANDERPC;Database=efzLager;Trusted_Connection=True;")
            .Options;

        using (var context = new efzLagerContext(contextOptions))
        {
            Kategorie k = new Kategorie()
            {
                Kategorie1 = "Häuser"
            };
            context.Add(k);
            context.SaveChanges();
        }
    }
}