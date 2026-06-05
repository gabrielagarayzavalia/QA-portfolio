using System.Net;
using System.Text.Json;
using Microsoft.Playwright;
using NUnit.Framework;

namespace QaPortfolio.PlaywrightApiTests;

[TestFixture]
public class AbmCrudAcTests
{
    private string? _createdId;

    [Test, Order(1)]
    public async Task AC001_CreateValidItem()
    {
        var response = await ApiTestFixture.Request.PostAsync("/api/items", new APIRequestContextOptions
        {
            DataObject = new { name = "Item QA-001", description = "Playwright", active = true }
        });
        Assert.That(response.Status, Is.EqualTo(201));
        var json = await response.JsonAsync();
        _createdId = json?.GetProperty("id").GetString();
        Assert.That(_createdId, Is.Not.Null.And.Not.Empty);
    }

    [Test, Order(2)]
    public async Task AC002_CreateInvalidName()
    {
        var response = await ApiTestFixture.Request.PostAsync("/api/items", new APIRequestContextOptions
        {
            DataObject = new { name = "" }
        });
        Assert.That(response.Status, Is.EqualTo(400));
    }

    [Test, Order(3)]
    public async Task AC003_ListPaged()
    {
        var response = await ApiTestFixture.Request.GetAsync("/api/items?page=0&size=10");
        Assert.That(response.Status, Is.EqualTo(200));
        var body = await response.JsonAsync();
        Assert.That(body!.TryGetProperty("content", out _), Is.True);
    }

    [Test, Order(4)]
    public async Task AC004_FilterActive()
    {
        var response = await ApiTestFixture.Request.GetAsync("/api/items?active=true");
        Assert.That(response.Status, Is.EqualTo(200));
    }

    [Test, Order(5)]
    public async Task AC005_GetById()
    {
        Assert.That(_createdId, Is.Not.Null);
        var response = await ApiTestFixture.Request.GetAsync($"/api/items/{_createdId}");
        Assert.That(response.Status, Is.EqualTo(200));
    }

    [Test, Order(6)]
    public async Task AC006_GetNotFound()
    {
        var response = await ApiTestFixture.Request.GetAsync(
            "/api/items/00000000-0000-0000-0000-000000000099");
        Assert.That(response.Status, Is.EqualTo(404));
    }

    [Test, Order(7)]
    public async Task AC007_UpdateItem()
    {
        var id = await CreateItemAsync();
        var response = await ApiTestFixture.Request.PutAsync($"/api/items/{id}", new APIRequestContextOptions
        {
            DataObject = new { name = "Item QA-007-up", active = false }
        });
        Assert.That(response.Status, Is.EqualTo(200));
        var json = await response.JsonAsync();
        Assert.That(json!.GetProperty("name").GetString(), Is.EqualTo("Item QA-007-up"));
    }

    [Test, Order(8)]
    public async Task AC008_UpdateNotFound()
    {
        var response = await ApiTestFixture.Request.PutAsync(
            "/api/items/00000000-0000-0000-0000-000000000099",
            new APIRequestContextOptions { DataObject = new { name = "X" } });
        Assert.That(response.Status, Is.EqualTo(404));
    }

    [Test, Order(9)]
    public async Task AC009_DeleteItem()
    {
        var id = await CreateItemAsync();
        var response = await ApiTestFixture.Request.DeleteAsync($"/api/items/{id}");
        Assert.That(response.Status, Is.EqualTo(204));
    }

    [Test, Order(10)]
    public async Task AC010_DeleteNotFound()
    {
        var response = await ApiTestFixture.Request.DeleteAsync(
            "/api/items/00000000-0000-0000-0000-000000000099");
        Assert.That(response.Status, Is.EqualTo(404));
    }

    private static async Task<string> CreateItemAsync()
    {
        var response = await ApiTestFixture.Request.PostAsync("/api/items", new APIRequestContextOptions
        {
            DataObject = new { name = $"Temp-{Guid.NewGuid()}", active = true }
        });
        Assert.That(response.Status, Is.EqualTo(201));
        var json = await response.JsonAsync();
        return json!.GetProperty("id").GetString()!;
    }
}
