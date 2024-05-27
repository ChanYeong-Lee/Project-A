using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using TMPro;
using UnityEngine;
using UnityEngine.Serialization;
using UnityEngine.UI;

public class UICraftMenu : ContentElement
{
    private enum CraftAmountButton
    {
        Default,
        Up,
        Down,
    }
    
    private List<UISlot> slots = new List<UISlot>();

    [SerializeField] private RectTransform content;
    
    private List<ItemRecipeData> recipeDataList = new List<ItemRecipeData>();
    private Inventory inventory;
    private UISlot slotPrefab;
    private UISlot selectedSlot;
    private Button selectedSortingButton;
    private UISlot prevSelectedSlot;
    private int currentCraftAmount;

    public UISlot SelectedSlot { get => selectedSlot; set => selectedSlot = value; }

    protected override void Awake()
    {
        base.Awake();
        
        recipeDataList = Managers.Data.RecipeDataList;
        
        if (inventory == null) 
            inventory = Managers.Game.Inventory;
        
        BindButtons();
    }

    private void OnEnable()
    {
        UpdateCraft();
        selectedSortingButton = buttons["All"];
    }
    
    private void Update()
    {
        ChangeSelectedSlot(Managers.Input.MoveUI);
        ChangeSortingSlot(Managers.Input.SortingMoveUI);
        
        if (prevSelectedSlot != selectedSlot)
            UpdateCraftItemInfo(selectedSlot);
      
        // 아이템 제작 키 입력 체크
        // if (Input.GetKeyDown(KeyCode.F) && CraftableAmount(selectedSlot.ItemData) > 0)
        // {
        //     Debug.Log("제작");
        //     inventory.CraftingItem(FindItemRecipe(selectedSlot.ItemData), currentCraftAmount);
        //
        //     foreach (UISlot slot in slots) 
        //         UpdateSlot(slot);
        //
        //     ChangeCraftAmount();
        // }
    }

    private void BindButtons()
    {
        buttons["All"].onClick.AddListener(() =>
        {
            selectedSortingButton = buttons["All"];
            UpdateCraft(Define.ItemType.None);
        });
        buttons["Arrows"].onClick.AddListener(() =>
        {
            selectedSortingButton = buttons["Arrows"];
            UpdateCraft(Define.ItemType.Arrow);
        });
        buttons["Consumptions"].onClick.AddListener(() =>
        {
            selectedSortingButton = buttons["Consumptions"];
            UpdateCraft(Define.ItemType.Consumption);
        });
        buttons["UpButton"].onClick.AddListener(() => ChangeCraftAmount(CraftAmountButton.Up));
        buttons["DownButton"].onClick.AddListener(() => ChangeCraftAmount(CraftAmountButton.Down));
        buttons["CraftButton"].onClick.AddListener(() =>
        {
            Debug.Log("제작");
            inventory.CraftingItem(FindItemRecipe(selectedSlot.Item), currentCraftAmount);
            
            foreach (UISlot slot in slots) 
                UpdateSlot(slot);
            
            ChangeCraftAmount();
        });
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
            if (itemType != Define.ItemType.None && itemType != recipeData.Item.ItemType)
                continue;
            
            var slot = Managers.Resource.Instantiate("Prefabs/UI/CraftSlot", content, true).GetComponent<UISlot>();

            slot.transform.SetSiblingIndex(i++);
            slot.SlotType = SlotType.CraftMenu;
            slot.Item = recipeData.Item;
            slots.Add(slot);

            UpdateSlot(slot);
        }
        
        selectedSlot = content.transform.GetComponentInChildren<UISlot>();
        selectedSlot.ChangeAlpha(1f);
    }
    
    // 제작 아이템 슬롯 업데이트 메소드
    private void UpdateSlot(UISlot slot)
    {
        var craftableAmount = CraftableAmount(slot.Item);

        slot.Images["Icon"].sprite = slot.Item.Icon;
        slot.Texts["NameText"].text = $"{slot.Item.ItemName}";
        slot.Texts["CraftableAmountText"].text = $"{craftableAmount}";
        // 보유하고 있는 아이템 개수
        slot.Texts["AmountText"].text = $"{inventory.ItemDataDic.GetValueOrDefault(slot.Item, 0)}";
    }
        
    // 제작 아이템 정보창 업데이트 메소드
    private void UpdateCraftItemInfo(UISlot slot)
    {
        prevSelectedSlot = selectedSlot;
        
        var recipeData = FindItemRecipe(slot.Item);

        images["IconImage"].sprite = slot.Item.Icon;
        texts["NameText"].text = $"{slot.Item.ItemName}";
        texts["AmountLabelText"].text = $"{recipeData.ItemCount}";
        texts["DescriptionText"].text = $"{slot.Item.Description}";
        
        for (var i = 0; i < recipeData.CraftItemData.Count; i++)
        {
            images[$"IconImage{i}"].sprite = recipeData.CraftItemData[i].Icon;
            texts[$"AmountLabelText{i}"].text = $"{recipeData.CraftItemCount[i]}";
        }

        ChangeCraftAmount();
    }
    
    private ItemRecipeData FindItemRecipe(Item item)
    {
        var recipeData = recipeDataList.Find(recipe => item == recipe.Item);

        return recipeData == null ? null : recipeData;
    }
    
    // 제작 가능한 아이템 확인 메소드
    private int CraftableAmount(Item item)
    {
        var recipeData = FindItemRecipe(item);
        List<int> craftableAmountList = new List<int>();
        
        for (int i = 0; i < recipeData.CraftItemData.Count; i++) 
            craftableAmountList.Add(inventory.ItemDataDic.GetValueOrDefault(recipeData.CraftItemData[i], 0) / recipeData.CraftItemCount[i]);

        return craftableAmountList.Min();
    }

    private void ChangeCraftAmount(CraftAmountButton button = CraftAmountButton.Default)
    {
        if (!int.TryParse(texts["CraftAmountText"].text, out int craftAmount))
            craftAmount = 0;

        switch (button)
        {
            case CraftAmountButton.Default:
                craftAmount = 0;
                break;
            case CraftAmountButton.Up:
                craftAmount++;
                break;
            case CraftAmountButton.Down:
                craftAmount--;
                break;
        }
        
        int maxAmount = CraftableAmount(selectedSlot.Item);
        
        if (craftAmount < 0) 
            craftAmount = 0;
        else if (craftAmount > maxAmount) 
            craftAmount = maxAmount;

        texts["CraftAmountText"].text = $"{craftAmount}";
        
        currentCraftAmount = craftAmount;
    }

    public void ChangeSelectedSlot(float value)
    {
        int i = slots.IndexOf(selectedSlot);
        if (i == -1)
            return;
        
        if (value > 0)
        {
            selectedSlot.ChangeAlpha(0.2f);
            selectedSlot = slots[(i + 1) % slots.Count];
        }
        else if (value < 0)
        {
            selectedSlot.ChangeAlpha(0.2f);
            selectedSlot = slots[i - 1 < 0 ? slots.Count - 1 : i - 1];
        }
        else
            return;
        
        selectedSlot.ChangeAlpha(1f);
    }

    public void ChangeSortingSlot(float value)
    {
        if (value < 0)
        {
            if (selectedSortingButton == buttons["All"])
            {
                buttons["Arrows"].onClick.Invoke();
            }
            else if (selectedSortingButton == buttons["Arrows"])
            {
                buttons["Consumptions"].onClick.Invoke();
            }
            else if (selectedSortingButton == buttons["Consumptions"])
            {
                buttons["All"].onClick.Invoke();
            }
        }
        else if (value > 0)
        {
            if (selectedSortingButton == buttons["All"])
            {
                buttons["Consumptions"].onClick.Invoke();
            }
            else if (selectedSortingButton == buttons["Arrows"])
            {
                buttons["All"].onClick.Invoke();
            }
            else if (selectedSortingButton == buttons["Consumptions"])
            {
                buttons["Arrows"].onClick.Invoke();
            }
        }
    }
}
