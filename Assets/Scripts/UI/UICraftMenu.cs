using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using TMPro;
using UnityEngine;
using UnityEngine.Serialization;

public class UICraftMenu : ContentElement
{
    private List<UISlot> slots = new List<UISlot>();

    // TODO : UIManager 생기면 다시 정리
    [SerializeField] private RectTransform content;
    [FormerlySerializedAs("text")] [SerializeField] private GameObject craftInfo;
    
    private List<ItemRecipeData> recipeDataList = new List<ItemRecipeData>();
    private Inventory inventory;
    private UISlot slotPrefab;
    private UISlot selectSlot;
    
    public UISlot SelectSlot { get => selectSlot; set => selectSlot = value; }

    protected override void Awake()
    {
        base.Awake();
    }

    private void OnEnable()
    {
        recipeDataList = Managers.Data.RecipeDataList;
        
        if (inventory == null) 
            inventory = Managers.Game.Player.GetComponentInChildren<Inventory>();
        
        buttons["All"].onClick.AddListener(() => UpdateCraft(Define.ItemType.None));
        buttons["Arrows"].onClick.AddListener(() => UpdateCraft(Define.ItemType.Arrow));
        buttons["Consumptions"].onClick.AddListener(() => UpdateCraft(Define.ItemType.Consumption));

        UpdateCraft();
    }
    
    private void Update()
    {
        if (selectSlot == null)
        {
            UpdateCraftItemInfo(slots[0]);
            return;
        }

        UpdateCraftItemInfo(selectSlot);
      
        // 아이템 제작 키 입력 체크
        if (Input.GetKeyDown(KeyCode.F) && CraftableAmount(selectSlot.ItemData) > 0)
        {
            Debug.Log("제작");
            inventory.CraftingItem(FindItemRecipe(selectSlot.ItemData));

            foreach (UISlot slot in slots) 
                UpdateSlot(slot);
        }
    }
    
    // 정렬할 itemType을 넣으면 정렬
    // None이면 전체
    private void UpdateCraft(Define.ItemType itemType = Define.ItemType.None)
    {
        foreach (UISlot slot in slots) 
            Managers.Pool.Push(slot.gameObject);
        
        slots.Clear();

        int i = 0;
        foreach (var recipeData in recipeDataList)
        {
            if (itemType != Define.ItemType.None && itemType != recipeData.ItemData.ItemType)
                continue;
            
            var slot = Managers.Resource.Instantiate("Prefabs/UI/CraftSlot", content, true).GetComponent<UISlot>();

            slot.transform.SetSiblingIndex(i++);
            slot.SlotType = SlotType.CraftMenu;
            slot.ItemData = recipeData.ItemData;
            slots.Add(slot);

            UpdateSlot(slot);
        }
    }
    
    // 제작 아이템 슬롯 업데이트 메소드
    private void UpdateSlot(UISlot slot)
    {
        var craftableAmount = CraftableAmount(slot.ItemData);

        slot.Images["Icon"].sprite = slot.ItemData.Icon;
        slot.Texts["NameText"].text = $"{slot.ItemData.ItemName}";
        slot.Texts["CraftableAmountText"].text = $"{craftableAmount}";
        // 보유하고 있는 아이템 개수
        slot.Texts["AmountText"].text = $"{inventory.ItemDataDic.GetValueOrDefault(slot.ItemData, 0)}";
    }
        
    // 제작 아이템 정보창 업데이트 메소드
    private void UpdateCraftItemInfo(UISlot slot)
    {
        var recipeData = FindItemRecipe(slot.ItemData);

        images["IconImage"].sprite = slot.ItemData.Icon;
        texts["NameText"].text = $"{slot.ItemData.ItemName}";
        texts["AmountLabelText"].text = $"{recipeData.ItemCount}";
        texts["DescriptionText"].text = $"{slot.ItemData.Description}";

        for (var i = 0; i < recipeData.CraftItemData.Count; i++)
        {
            images[$"IconImage{i}"].sprite = recipeData.CraftItemData[i].Icon;
            texts[$"AmountLabelText{i}"].text = $"{recipeData.CraftItemCount[i]}";
        }
    }
    
    private ItemRecipeData FindItemRecipe(ItemData itemData)
    {
        var recipeData = recipeDataList.Find(recipe => itemData == recipe.ItemData);

        return recipeData == null ? null : recipeData;
    }
    
    // 제작 가능한 아이템 확인 메소드
    private int CraftableAmount(ItemData itemData)
    {
        var recipeData = FindItemRecipe(itemData);
        List<int> craftableAmountList = new List<int>();
        
        for (int i = 0; i < recipeData.CraftItemData.Count; i++) 
            craftableAmountList.Add(inventory.ItemDataDic.GetValueOrDefault(recipeData.CraftItemData[i], 0) / recipeData.CraftItemCount[i]);

        return craftableAmountList.Min();
    }
}
