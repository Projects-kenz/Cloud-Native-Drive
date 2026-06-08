
var builder = WebApplication.CreateBuilder(args);

builder.Services.AddCors(options =>
{
    options.AddPolicy("angular", p =>
        p.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod());
});

var app = builder.Build();

app.UseCors("angular");

app.MapGet("/api/health", () => new
{
    application = "DevOps Portfolio Demo",
    status = "UP",
    timestamp = DateTime.UtcNow
});

app.Run();
