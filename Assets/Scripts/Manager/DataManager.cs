using System.Collections.Generic;
using UnityEngine;

public class DataManager
{
    private List<ItemRecipeData> recipeDataList = new List<ItemRecipeData>();
    
    public List<ItemRecipeData> RecipeDataList => recipeDataList;

    public void Init()
    {
        recipeDataList.AddRange(Managers.Resource.LoadAll<ItemRecipeData>(Define.RecipeDataPath+"Arrow"));
        recipeDataList.AddRange(Managers.Resource.LoadAll<ItemRecipeData>(Define.RecipeDataPath+"Potion"));
    }
    
}