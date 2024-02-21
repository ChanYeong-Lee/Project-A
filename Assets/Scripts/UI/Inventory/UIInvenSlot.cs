using UnityEngine.EventSystems;

public class UIInvenSlot : UISlot, IPointerClickHandler
{
    public void OnPointerClick(PointerEventData eventData)
    {
        transform.GetComponentInParent<UIInventory>().SelectSlot = this;
        isSelected = true;
    }
}