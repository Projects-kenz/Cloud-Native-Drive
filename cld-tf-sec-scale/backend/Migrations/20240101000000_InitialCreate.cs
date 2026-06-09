using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace DemoApp.Migrations;

public partial class InitialCreate : Migration
{
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.CreateTable(
            name: "Products",
            columns: table => new
            {
                Id          = table.Column<int>(nullable: false)
                                   .Annotation("Npgsql:ValueGenerationStrategy",
                                               NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                Name        = table.Column<string>(nullable: false),
                Description = table.Column<string>(nullable: false),
                Price       = table.Column<decimal>(nullable: false),
                Stock       = table.Column<int>(nullable: false),
                CreatedAt   = table.Column<DateTime>(nullable: false)
            },
            constraints: table => table.PrimaryKey("PK_Products", x => x.Id));

        migrationBuilder.InsertData("Products",
            new[] { "Id","Name","Description","Price","Stock","CreatedAt" },
            new object[] { 1,"Laptop","15-inch development laptop",1200.00m,10,new DateTime(2024,1,1,0,0,0,DateTimeKind.Utc) });
        migrationBuilder.InsertData("Products",
            new[] { "Id","Name","Description","Price","Stock","CreatedAt" },
            new object[] { 2,"Monitor","27-inch 4K display",450.00m,25,new DateTime(2024,1,1,0,0,0,DateTimeKind.Utc) });
        migrationBuilder.InsertData("Products",
            new[] { "Id","Name","Description","Price","Stock","CreatedAt" },
            new object[] { 3,"Keyboard","Mechanical TKL keyboard",95.00m,50,new DateTime(2024,1,1,0,0,0,DateTimeKind.Utc) });
    }

    protected override void Down(MigrationBuilder migrationBuilder)
        => migrationBuilder.DropTable(name: "Products");
}
