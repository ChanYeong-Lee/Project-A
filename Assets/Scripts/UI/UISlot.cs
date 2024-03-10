using System;
using TMPro;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class UISlot : UIBase, IPointerClickHandler
{
    // TODO : UI에 따라 slot이 가지고 있는 item 값 바꿀 필요 있음.
    private ItemData itemData;


    private TextMeshProUGUI text;
    private SlotType slotType;

    public ItemData ItemData { get => itemData; set => itemData = value; }

    public TextMeshProUGUI Text { get => text; set => text = value; }
    public SlotType SlotType { get => slotType; set => slotType = value; }

    protected override void Awake()
    {
        base.Awake();
        text = GetComponentInChildren<TextMeshProUGUI>();
    }

    public void OnPointerClick(PointerEventData eventData)
    {
        switch (slotType)
        {
            case SlotType.InventoryMenu: 
                transform.GetComponentInParent<UIInventory>().SelectedSlot.ChangeAlpha(0.2f);
                transform.GetComponentInParent<UIInventory>().SelectedSlot = this;
                ChangeAlpha(1f);
                break;
            case SlotType.CraftMenu:
                transform.GetComponentInParent<UICraftMenu>().SelectedSlot.ChangeAlpha(0.2f);
                transform.GetComponentInParent<UICraftMenu>().SelectedSlot = this;
                break;
            case SlotType.QuestMenu:
                transform.GetComponentInParent<UIQuestMenu>().SelectedSlot.ChangeAlpha(0.2f);
                transform.GetComponentInParent<UIQuestMenu>().SelectedSlot = this;
                break;
        }
        
        ChangeAlpha(1f);
    }
    
    public void ChangeAlpha(float alpha)
    {
        Color color = GetComponent<Image>().color;
        color = ColorHelper.SetColorAlpha(color, alpha);
        
        GetComponent<Image>().color = color;
    }

    private void OnDisable()
    {
        ChangeAlpha(0.2f);
    }
}



public enum SlotType
{
    InventoryMenu,
    CraftMenu,
    QuestMenu,
}