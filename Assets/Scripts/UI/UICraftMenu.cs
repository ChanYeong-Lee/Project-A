using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using TMPro;
using UnityEngine;
using UnityEngine.Serialization;

public class UICraftMenu : UIBase
{
    private List<UISlot> slots = new List<UISlot>();

    // TODO : 인벤토리 참조는 Managers.Game.Player.inventory로 바꾸기
    // TODO : UIManager 생기면 다시 정리
    [SerializeField] private Inventory inventory;
    [SerializeField] private RectTransform content;
    [SerializeField] private TextMeshProUGUI text;
    [SerializeField] private UISlot slotPrefab;
    
    private UISlot selectSlot;
    private List<ItemRecipeData> recipeDataList = new List<ItemRecipeData>();
    
    public UISlot SelectSlot { get => selectSlot; set => selectSlot = value; }
    
    private void OnEnable()
    {
        recipeDataList = Managers.Data.RecipeDataList;
        
        foreach (UISlot slot in slots) 
            Managers.Pool.Push(slot.gameObject);
        
        slots.Clear();
        
        foreach (var recipeData in recipeDataList)
        {
            var slot = Managers.Pool.Pop(slotPrefab.gameObject, content).GetComponent<UISlot>();
            
            slot.SlotType = SlotType.CraftMenu;
            slot.ItemData = recipeData.ItemData;
            
            slots.Add(slot);

            UpdateSlot(slot);
        }
    }
    
    private void Update()
    {
        if (selectSlot == null)
            return;

        UpdateCraftItemInfo(selectSlot);
      
        // 아이템 제작 키 입력 체크
        if (Input.GetKeyDown(KeyCode.F) && IsCheckCraftItem(selectSlot.ItemData))
        {
            Debug.Log("제작");
            inventory.CraftingItem(FindItemRecipe(selectSlot.ItemData));
            UpdateSlot(selectSlot);
        }
    }
    
    // 제작 아이템 정보창 업데이트 메소드
    private void UpdateCraftItemInfo(UISlot slot)
    {
        var recipeData = FindItemRecipe(slot.ItemData);
        StringBuilder sb = new StringBuilder();
        
        sb.Append($"{recipeData.ItemData.ItemName} X{recipeData.ItemCount}\n");
        sb.Append("재료\n");

        for (var i = 0; i < recipeData.CraftItemData.Count; i++)
        {
            var itemData = recipeData.CraftItemData[i];
            var itemCount = recipeData.CraftItemCount[i];
            int currentItemCount = inventory.ItemDataDic.GetValueOrDefault(itemData, 0);
            
            sb.Append($"{itemData.ItemName} : {currentItemCount}/{itemCount}\n");
        }

        text.text = sb.ToString();
    }
    
    // 제작 아이템 슬롯 업데이트 메소드
    private void UpdateSlot(UISlot slot)
    {
        var recipeData = FindItemRecipe(slot.ItemData);
        
        slot.Text.color = IsCheckCraftItem(slot.ItemData) ? Color.blue : Color.red;
        slot.Text.text = $"{slot.ItemData.ItemName} X{recipeData.ItemCount}";
    }

    private ItemRecipeData FindItemRecipe(ItemData itemData)
    {
        var recipeData = recipeDataList.Find(recipe => itemData == recipe.ItemData);

        return recipeData == null ? null : recipeData;
    }
    
    // 제작 가능한 아이템 확인 메소드
    private bool IsCheckCraftItem(ItemData itemData)
    {
        var recipeData = FindItemRecipe(itemData);
        var craftItemData = recipeData.CraftItemData;
        
        for (var i = 0; i < craftItemData.Count; i++)
        {
            if (!inventory.ItemDataDic.TryGetValue(craftItemData[i], out int count) || count < recipeData.CraftItemCount[i])
            {
                return false;
            }
        }

        return true;
    }
}
