# frozen_string_literal: true

# The Registry of Names
#
# All components available to views are declared here. There is no
# method_missing sorcery, no dynamic resolution, no convention-based guessing.
# If a component is not in the registry, it does not exist.
#
# To create a new component: add one line to COMPONENT_MAP and create the class.
#
# See: specs/the-holy-view-spec.md, Article 3

module ComponentHelper
  COMPONENT_MAP = {
    # Layout Primitives
    VStack:      VStackComponent,
    HStack:      HStackComponent,
    Column:      ColumnComponent,
    Row:         RowComponent,
    Pusher:      PusherComponent,
    Overlay:     OverlayComponent,
    Link:        LinkComponent,
    SubHeader:   SubHeaderComponent,

    # Globals
    Reset:       ResetComponent,
    Site:        SiteComponent,

    # Elements
    Button:      ButtonComponent,
    Container:   ContainerComponent,
    Divider:     DividerComponent,
    Emoji:       EmojiComponent,
    Flag:        FlagComponent,
    Header:      HeaderComponent,
    Icon:        IconComponent,
    Image:       ImageComponent,
    Input:       InputComponent,
    Label:       LabelComponent,
    List:        ListComponent,
    Loader:      LoaderComponent,
    Placeholder: PlaceholderComponent,
    Rail:        RailComponent,
    Reveal:      RevealComponent,
    Segment:      SegmentComponent,
    SegmentGroup: SegmentGroupComponent,
    Step:        StepComponent,
    StepGroup:   StepGroupComponent,
    Text:        TextComponent,

    # Collections
    Breadcrumb:  BreadcrumbComponent,
    Form:        FormComponent,
    Grid:        GridComponent,
    Menu:        MenuComponent,
    MenuItem:    MenuItemComponent,
    SubMenu:     SubMenuComponent,
    Message:     MessageComponent,
    Table:       TableComponent,
    TableRow:    TableRowComponent,
    TableCell:   TableCellComponent,

    # Views
    Ad:          AdComponent,
    ItemGroup:   ItemGroupComponent,
    Card:        CardComponent,
    Comment:     CommentComponent,
    Feed:        FeedComponent,
    Item:        ItemComponent,
    Statistic:   StatisticComponent,

    # Modules
    Accordion:   AccordionComponent,
    Calendar:    CalendarComponent,
    Checkbox:    CheckboxComponent,
    Dimmer:      DimmerComponent,
    Dropdown:    DropdownComponent,
    Embed:       EmbedComponent,
    Flyout:      FlyoutComponent,
    Modal:       ModalComponent,
    Nag:         NagComponent,
    Popup:       PopupComponent,
    Progress:    ProgressComponent,
    Slider:      SliderComponent,
    Rating:      RatingComponent,
    Search:      SearchComponent,
    Shape:       ShapeComponent,
    Sidebar:     SidebarComponent,
    Sticky:      StickyComponent,
    Tab:         TabComponent,
    Toast:       ToastComponent,
    Transition:  TransitionComponent,

    # Behaviors
    Api:         ApiComponent,
    State:       StateComponent,
    Visibility:  VisibilityComponent
  }.freeze

  COMPONENT_MAP.each do |name, klass|
    define_method(name) { |**kwargs, &block|
      output_buffer << render(klass.new(**kwargs), &block)
    }
  end

  def text(content)
    output_buffer << content.to_s
  end
end
