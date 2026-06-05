namespace QaPortfolio.DotNetApi.Models;

public record ItemDto(Guid Id, string Name, string Description, bool Active, DateTime CreatedAt);

public record ItemCreateDto(string Name, string? Description, bool? Active);

public record ItemUpdateDto(string? Name, string? Description, bool? Active);

public record PagedItemsDto(
    IReadOnlyList<ItemDto> Content,
    int Page,
    int Size,
    long TotalElements,
    int TotalPages);

public record ErrorDto(string Message);
