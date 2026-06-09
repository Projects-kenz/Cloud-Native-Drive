using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;

namespace DemoApp.Migrations;

[DbContext(typeof(DemoApp.Data.AppDbContext))]
[Migration("20240101000000_InitialCreate")]
partial class InitialCreate
{
    protected override void BuildTargetModel(ModelBuilder modelBuilder)
    {
        modelBuilder.HasAnnotation("ProductVersion", "8.0.0")
                    .HasAnnotation("Relational:MaxIdentifierLength", 63);
        NpgsqlModelBuilderExtensions.UseIdentityByDefaultColumns(modelBuilder);

        modelBuilder.Entity("DemoApp.Models.Product", b =>
        {
            b.Property<int>("Id").ValueGeneratedOnAdd()
             .HasColumnType("integer");
            NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<int>("Id"));
            b.Property<DateTime>("CreatedAt").HasColumnType("timestamp with time zone");
            b.Property<string>("Description").IsRequired().HasColumnType("text");
            b.Property<string>("Name").IsRequired().HasColumnType("text");
            b.Property<decimal>("Price").HasColumnType("numeric");
            b.Property<int>("Stock").HasColumnType("integer");
            b.HasKey("Id");
            b.ToTable("Products");
            b.HasData(
                new { Id = 1, Name = "Laptop",   Description = "15-inch development laptop", Price = 1200.00m, Stock = 10, CreatedAt = new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                new { Id = 2, Name = "Monitor",  Description = "27-inch 4K display",          Price = 450.00m,  Stock = 25, CreatedAt = new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) },
                new { Id = 3, Name = "Keyboard", Description = "Mechanical TKL keyboard",     Price = 95.00m,   Stock = 50, CreatedAt = new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc) }
            );
        });
    }
}
