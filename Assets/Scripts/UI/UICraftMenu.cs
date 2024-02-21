using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using TMPro;
using UnityEngine;
using UnityEngine.Serialization;

public class UICraftMenu : MonoBehaviour
{
    private List<UICraftSlot> slots = new List<UICraftSlot>();

    // TODO : 인벤토리 참조는 Managers.Game.Player.inventory로 바꾸기
    // TODO : UIManager 생기면 다시 정리
    [SerializeField] private Inventory inventory;
    [SerializeField] private List<ItemRecipeData> recipeDataList;
    [SerializeField] private RectTransform content;
    [SerializeField] private TextMeshProUGUI text;
    [SerializeField] private UICraftSlot slotPrefab;
    private UICraftSlot selectSlot;

    public UICraftSlot SelectSlot { get => selectSlot; set => selectSlot = value; }
    
    private void OnEnable()
    {
        foreach (UICraftSlot slot in slots) 
            Managers.Pool.Push(slot.gameObject);
        
        slots.Clear();
        
        foreach (var recipeData in recipeDataList)
        {
            var slot = Managers.Pool.Pop(slotPrefab.gameObject, content).GetComponent<UICraftSlot>();
            slot.RecipeData = recipeData;
            
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
        if (Input.GetKeyDown(KeyCode.F) && IsCheckCreateItem(selectSlot.RecipeData))
        {
            Debug.Log("제작");
            inventory.CraftingItem(selectSlot.RecipeData);
            UpdateSlot(selectSlot);
        }
    }
    
    // 제작 아이템 정보창 업데이트 메소드
    private void UpdateCraftItemInfo(UICraftSlot slot)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append($"{slot.RecipeData.ItemData.ItemName} X{slot.RecipeData.ItemCount}\n");
        sb.Append("재료\n");

        for (var i = 0; i < slot.RecipeData.CraftItemData.Count; i++)
        {
            var itemData = slot.RecipeData.CraftItemData[i];
            var itemCount = slot.RecipeData.CraftItemCount[i];
            sb.Append($"{itemData.ItemName} : {inventory.ItemDataDic[itemData]}/{itemCount}\n");
        }
    }
    
    // 제작 아이템 슬롯 업데이트 메소드
    private void UpdateSlot(UICraftSlot slot)
    {
        slot.Text.color = IsCheckCreateItem(slot.RecipeData) ? Color.blue : Color.red;
        slot.Text.text = $"{slot.RecipeData.ItemData.ItemName} X{slot.RecipeData.ItemCount}";
    }

    // 제작 가능한 아이템 확인 메소드
    private bool IsCheckCreateItem(ItemRecipeData recipeData)
    {
        var craftItemData = recipeData.CraftItemData;
        
        for (var i = 0; i < craftItemData.Count; i++)
        {
            var itemData = craftItemData[i];

            if (!inventory.ItemDataDic.TryGetValue(itemData, out int count) || count < recipeData.CraftItemCount[i])
            {
                return false;
            }
        }

        return true;
    }
}
