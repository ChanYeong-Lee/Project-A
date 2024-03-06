using System.Collections.Generic;
using UnityEngine;

public class DataManager
{
    private List<ItemRecipeData> recipeDataList = new List<ItemRecipeData>();
    
    public List<ItemRecipeData> RecipeDataList => recipeDataList;

    //public List<QuestInfoSo> questSoList = new List<QuestInfoSo>();

    public void Init()
    {
        recipeDataList.AddRange(Managers.Resource.LoadAll<ItemRecipeData>(Define.RecipeDataPath+"Arrow"));
        recipeDataList.AddRange(Managers.Resource.LoadAll<ItemRecipeData>(Define.RecipeDataPath+"Potion"));
        //TODO: QuestManager의 데이터를 불러올지 아래처럼 Load할지 정할 것
        //questSoList.AddRange(Managers.Resource.LoadAll<QuestInfoSo>(Define.questDataPath+"CollectibleWood"));
        //questSoList.AddRange(Managers.Resource.LoadAll<QuestInfoSo>(Define.questDataPath+"VisitUnknowWorld"));
    }
    
}