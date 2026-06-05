using Microsoft.AspNetCore.Mvc;
using QaPortfolio.DotNetApi.Models;
using QaPortfolio.DotNetApi.Services;

namespace QaPortfolio.DotNetApi.Controllers;

[ApiController]
[Route("api/items")]
public class ItemsController : ControllerBase
{
    private readonly ItemStore _store;

    public ItemsController(ItemStore store) => _store = store;

    [HttpGet]
    public PagedItemsDto List([FromQuery] int page = 0, [FromQuery] int size = 20, [FromQuery] bool? active = null)
        => _store.List(page, size, active);

    [HttpPost]
    public IActionResult Create([FromBody] ItemCreateDto? body)
    {
        if (body == null || string.IsNullOrWhiteSpace(body.Name))
            return BadRequest(new ErrorDto("name is required and must not be empty"));
        var item = _store.Create(body);
        return StatusCode(StatusCodes.Status201Created, item);
    }

    [HttpGet("{id:guid}")]
    public IActionResult Get(Guid id)
    {
        var item = _store.Get(id);
        return item == null
            ? NotFound(new ErrorDto("Item not found"))
            : Ok(item);
    }

    [HttpPut("{id:guid}")]
    public IActionResult Update(Guid id, [FromBody] ItemUpdateDto? body)
    {
        if (body?.Name != null && string.IsNullOrWhiteSpace(body.Name))
            return BadRequest(new ErrorDto("name must not be empty when provided"));
        var item = _store.Update(id, body ?? new ItemUpdateDto(null, null, null));
        return item == null
            ? NotFound(new ErrorDto("Item not found"))
            : Ok(item);
    }

    [HttpDelete("{id:guid}")]
    public IActionResult Delete(Guid id)
    {
        if (!_store.Delete(id))
            return NotFound(new ErrorDto("Item not found"));
        return NoContent();
    }
}
