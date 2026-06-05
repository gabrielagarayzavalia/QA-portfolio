using Microsoft.Playwright;

namespace QaPortfolio.PlaywrightApiTests;

[SetUpFixture]
public class ApiTestFixture
{
    public static string BaseUrl { get; private set; } = "http://localhost:3000";
    public static IPlaywright PlaywrightInstance { get; private set; } = null!;
    public static IAPIRequestContext Request { get; private set; } = null!;

    [OneTimeSetUp]
    public async Task GlobalSetup()
    {
        BaseUrl = Environment.GetEnvironmentVariable("SUT_BASE_URL") ?? "http://localhost:3000";
        PlaywrightInstance = await Playwright.CreateAsync();
        Request = await PlaywrightInstance.APIRequest.NewContextAsync(new APIRequestNewContextOptions
        {
            BaseURL = BaseUrl
        });
    }

    [OneTimeTearDown]
    public async Task GlobalTeardown()
    {
        await Request.DisposeAsync();
        PlaywrightInstance.Dispose();
    }
}
