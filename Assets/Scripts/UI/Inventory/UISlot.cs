using System;
using TMPro;
using UnityEngine;
using UnityEngine.EventSystems;

public class UISlot : MonoBehaviour
{
    // TODO : UI에 따라 slot이 가지고 있는 item 값 바꿀 필요 있음.
    private ItemData itemData;
    private TextMeshProUGUI text;

    protected bool isSelected;
    
    public bool IsSelected { get => isSelected; set => isSelected = value; }
    
    public ItemData ItemData { get => itemData; set => itemData = value; }
    public TextMeshProUGUI Text { get => text; set => text = value; }

    private void Awake()
    {
        text = GetComponentInChildren<TextMeshProUGUI>();
    }

    // public void OnPointerClick(PointerEventData eventData)
    // {
    //     transform.GetComponentInParent<UIInventory>().SelectSlot = this;
    //     isSelected = true;
    // }
}