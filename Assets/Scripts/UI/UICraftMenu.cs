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

    // TODO : �κ��丮 ������ Managers.Game.Player.inventory�� �ٲٱ�
    // TODO : UIManager ����� �ٽ� ����
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
      
        // ������ ���� Ű �Է� üũ
        if (Input.GetKeyDown(KeyCode.F) && IsCheckCreateItem(selectSlot.RecipeData))
        {
            Debug.Log("����");
            inventory.CraftingItem(selectSlot.RecipeData);
            UpdateSlot(selectSlot);
        }
    }
    
    // ���� ������ ����â ������Ʈ �޼ҵ�
    private void UpdateCraftItemInfo(UICraftSlot slot)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append($"{slot.RecipeData.ItemData.ItemName} X{slot.RecipeData.ItemCount}\n");
        sb.Append("���\n");

        for (var i = 0; i < slot.RecipeData.CraftItemData.Count; i++)
        {
            var itemData = slot.RecipeData.CraftItemData[i];
            var itemCount = slot.RecipeData.CraftItemCount[i];
            sb.Append($"{itemData.ItemName} : {inventory.ItemDataDic[itemData]}/{itemCount}\n");
        }
    }
    
    // ���� ������ ���� ������Ʈ �޼ҵ�
    private void UpdateSlot(UICraftSlot slot)
    {
        slot.Text.color = IsCheckCreateItem(slot.RecipeData) ? Color.blue : Color.red;
        slot.Text.text = $"{slot.RecipeData.ItemData.ItemName} X{slot.RecipeData.ItemCount}";
    }

    // ���� ������ ������ Ȯ�� �޼ҵ�
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
