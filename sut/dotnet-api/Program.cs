using System.Reflection;
using Microsoft.OpenApi.Models;
using QaPortfolio.DotNetApi.Services;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddSingleton<ItemStore>();
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo
    {
        Title = "ABM Items API",
        Version = "v1",
        Description = "SUT .NET - contract-first QA portfolio"
    });
});

var app = builder.Build();

app.UseSwagger();
app.UseSwaggerUI(c => c.SwaggerEndpoint("/swagger/v1/swagger.json", "ABM Items API v1"));

app.MapGet("/health", () => Results.Json(new { status = "ok", sut = "dotnet-api" }));
app.MapControllers();

app.Run();
