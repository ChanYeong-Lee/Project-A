using UnityEngine.EventSystems;

public class UICraftSlot : UISlot, IPointerClickHandler
{
    private ItemRecipeData recipeData;
    
    public ItemRecipeData RecipeData { get => recipeData; set => recipeData = value; }
    
    public void OnPointerClick(PointerEventData eventData)
    {
        transform.GetComponentInParent<UICraftMenu>().SelectSlot = this;
        isSelected = true;
    }
}