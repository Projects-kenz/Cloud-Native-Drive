using DemoApp.Models;
using Microsoft.EntityFrameworkCore;

namespace DemoApp.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

    public DbSet<Product> Products => Set<Product>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        // Seed data
        modelBuilder.Entity<Product>().HasData(
            new Product { Id = 1, Name = "Laptop",     Description = "15-inch development laptop", Price = 1200.00m, Stock = 10, CreatedAt = DateTime.UtcNow },
            new Product { Id = 2, Name = "Monitor",    Description = "27-inch 4K display",          Price = 450.00m,  Stock = 25, CreatedAt = DateTime.UtcNow },
            new Product { Id = 3, Name = "Keyboard",   Description = "Mechanical TKL keyboard",     Price = 95.00m,   Stock = 50, CreatedAt = DateTime.UtcNow }
        );
    }
}
