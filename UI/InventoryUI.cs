using Godot;
using System.Collections.Generic;

public partial class InventoryUI : Control
{
    private List<string> inventory = new List<string>();

    public void AddItem(string itemName)
    {
        if (inventory.Count < 9)  // Max 9 items
        {
            inventory.Add(itemName);
            UpdateInventoryUI();
        }
    }

    private void UpdateInventoryUI()
    {
        for (int i = 0; i < inventory.Count; i++)
        {
            GetNode<Button>($"GridContainer/Button{i}").Text = inventory[i];
        }
    }
}
