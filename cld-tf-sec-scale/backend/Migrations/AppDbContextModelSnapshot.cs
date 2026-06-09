using System;
using DemoApp.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;

namespace DemoApp.Migrations;

[DbContext(typeof(AppDbContext))]
partial class AppDbContextModelSnapshot : ModelSnapshot
{
    protected override void BuildModel(ModelBuilder modelBuilder)
    {
        modelBuilder.HasAnnotation("ProductVersion", "8.0.0")
                    .HasAnnotation("Relational:MaxIdentifierLength", 63);
        NpgsqlModelBuilderExtensions.UseIdentityByDefaultColumns(modelBuilder);

        modelBuilder.Entity("DemoApp.Models.Product", b =>
        {
            b.Property<int>("Id").ValueGeneratedOnAdd().HasColumnType("integer");
            NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<int>("Id"));
            b.Property<DateTime>("CreatedAt").HasColumnType("timestamp with time zone");
            b.Property<string>("Description").IsRequired().HasColumnType("text");
            b.Property<string>("Name").IsRequired().HasColumnType("text");
            b.Property<decimal>("Price").HasColumnType("numeric");
            b.Property<int>("Stock").HasColumnType("integer");
            b.HasKey("Id");
            b.ToTable("Products");
        });
    }
}
