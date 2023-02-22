using System;
using System.Collections.Generic;

namespace efzLagerEFDbFirst.Models
{
    public partial class ArtikelImport
    {
        public string? EnglishProductName { get; set; }
        public short? SafetyStockLevel { get; set; }
        public string? Color { get; set; }
        public string? EnglishProductSubcategoryName { get; set; }
        public string? EnglishProductCategoryName { get; set; }
        public decimal? PriceUsd { get; set; }
        public decimal? PriceEur { get; set; }
    }
}
