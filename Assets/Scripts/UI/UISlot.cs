using System;
using TMPro;
using UnityEngine;
using UnityEngine.EventSystems;

public class UISlot : UIBase, IPointerClickHandler
{
    // TODO : UI에 따라 slot이 가지고 있는 item 값 바꿀 필요 있음.
    private ItemData itemData;
    private QuestInfoSo questInfo;

    private TextMeshProUGUI text;
    private SlotType slotType;

    public ItemData ItemData { get => itemData; set => itemData = value; }

    public QuestInfoSo QuestInfo { get => questInfo; set => questInfo = value; }
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
                transform.GetComponentInParent<UIInventory>().SelectSlot = this;
                break;
            case SlotType.CraftMenu:
                transform.GetComponentInParent<UICraftMenu>().SelectSlot = this;
                break;
            case SlotType.QuestMenu:
                transform.GetComponentInParent<UIQuestMenu>().SelectedSlot = this;
                break;
        }
    }
}

public enum SlotType
{
    InventoryMenu,
    CraftMenu,
    QuestMenu,
}