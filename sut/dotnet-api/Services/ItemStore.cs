using System.Collections.Concurrent;
using QaPortfolio.DotNetApi.Models;

namespace QaPortfolio.DotNetApi.Services;

public class ItemStore
{
    private readonly ConcurrentDictionary<Guid, ItemDto> _items = new();

    public ItemDto Create(ItemCreateDto req)
    {
        var id = Guid.NewGuid();
        var item = new ItemDto(
            id,
            req.Name.Trim(),
            req.Description ?? string.Empty,
            req.Active ?? true,
            DateTime.UtcNow);
        _items[id] = item;
        return item;
    }

    public ItemDto? Get(Guid id) => _items.TryGetValue(id, out var item) ? item : null;

    public ItemDto? Update(Guid id, ItemUpdateDto req)
    {
        if (!_items.TryGetValue(id, out var existing)) return null;
        var name = req.Name != null ? req.Name.Trim() : existing.Name;
        var description = req.Description ?? existing.Description;
        var active = req.Active ?? existing.Active;
        var updated = existing with { Name = name, Description = description, Active = active };
        _items[id] = updated;
        return updated;
    }

    public bool Delete(Guid id) => _items.TryRemove(id, out _);

    public PagedItemsDto List(int page, int size, bool? active)
    {
        IEnumerable<ItemDto> all = _items.Values;
        if (active.HasValue)
            all = all.Where(i => i.Active == active.Value);
        var sorted = all.OrderByDescending(i => i.CreatedAt).ToList();
        var total = sorted.Count;
        var totalPages = total == 0 ? 0 : (int)Math.Ceiling(total / (double)size);
        var content = sorted.Skip(page * size).Take(size).ToList();
        return new PagedItemsDto(content, page, size, total, totalPages);
    }
}
